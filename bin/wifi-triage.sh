#!/bin/zsh
# One-shot "connected but no internet" triage. Runs entirely offline and writes
# a report file — so you can join the broken network, run this, switch back to a
# working connection, and hand over the file.
#
#   ~/bin/wifi-triage.sh            -> ~/wifi-triage-<HHMMSS>.txt
#
# Each layer is checked separately so the failure localises itself:
#   assoc -> DHCP -> ARP to gateway -> ping gateway -> route out -> DNS -> captive

OUT=${1:-$HOME/wifi-triage-$(date +%H%M%S).txt}
exec > >(tee "$OUT") 2>&1

print "=== wifi-triage $(date '+%F %T') ==="

print "\n--- 1. association ---"
system_profiler SPAirPortDataType 2>/dev/null |
  sed -n '/Current Network Information/,/Other Local/p' |
  grep -E 'Channel|Signal|Transmit|MCS|PHY|Security|^ {12}[^ ]' | head -12
networksetup -getairportnetwork en0

print "\n--- 2. IP / DHCP lease ---"
ifconfig en0 | grep -E 'status:|inet |ether|flags'
ip=$(ipconfig getifaddr en0 2>/dev/null)
# A missing IPv4 is only damning if there is no global IPv6 either — an iPhone
# hotspot is legitimately IPv6-only, and would otherwise read as a hard failure.
v6=$(ifconfig en0 | awk '/inet6 [^f]/ && !/fe80/ {print $2; exit}')
if [[ -z $ip && -n $v6 ]]; then
  print "note: no IPv4, but global IPv6 present ($v6) — IPv6-only link, not a DHCP failure"
elif [[ -z $ip ]]; then
  print "!! en0 has NO IPv4 AND NO GLOBAL IPv6 -> DHCP never completed"
elif [[ $ip == 169.254.* ]]; then
  print "!! SELF-ASSIGNED ($ip) -> DHCP request went unanswered"
else
  print "ok: $ip"
fi
print "\n[dhcp packet]"
ipconfig getpacket en0 2>/dev/null | grep -iE 'yiaddr|router|domain_name_server|lease_time|server_identifier|subnet_mask' ||
  print "(no DHCP packet — lease absent)"

print "\n--- 3. gateway reachability ---"
GW=$(netstat -rn -f inet | awk '$1=="default" && $NF=="en0"{print $2; exit}')
print "gateway: ${GW:-NONE}"
if [[ -n $GW ]]; then
  # An incomplete ARP entry means the router is not answering at layer 2 at all,
  # which is a very different fault from "router answers but has no uplink".
  ping -c 3 -W 1500 "$GW" 2>&1 | tail -3
  print "[arp] $(arp -n "$GW" 2>&1)"
fi

print "\n--- 4. beyond the gateway ---"
for h in 1.1.1.1 9.9.9.9; do
  printf "%-10s " "$h"
  ping -c 3 -W 2000 "$h" 2>/dev/null | tail -1 || print "unreachable"
done
print "[tcp 443]"
for h in 1.1.1.1 9.9.9.9; do
  printf "%-10s " "$h"
  curl -s -o /dev/null --connect-timeout 4 -w 'connect=%{time_connect}s http=%{http_code}\n' "https://$h" 2>&1 || print "FAILED"
done

print "\n--- 5. traceroute (where does it die?) ---"
traceroute -w 2 -q 2 -m 8 1.1.1.1 2>&1 | head -12

print "\n--- 6. DNS ---"
scutil --dns 2>/dev/null | grep -E 'nameserver\[[0-9]\]' | sort -u | head -5
dig +time=3 +tries=1 apple.com 2>&1 | grep -E 'Query time|ANSWER SECTION|status:|connection timed out' | head -4

print "\n--- 7. captive portal ---"
# Apple's own check; anything other than the exact Success page means a portal
# is intercepting, which looks identical to "no internet" from the browser.
curl -s -m 6 -o /dev/null -w 'http=%{http_code} redirect=%{redirect_url}\n' http://captive.apple.com/hotspot-detect.html
curl -s -m 6 http://captive.apple.com/hotspot-detect.html 2>/dev/null | head -3

print "\n--- 8. IPv6-only mode / NAT64 (RFC 8925) ---"
# macOS honours DHCP option 108 "IPv6-Only Preferred": if the network sets it,
# the IPv4 client is suppressed entirely and the Mac relies on NAT64 to reach
# IPv4 hosts. If the network sets it WITHOUT providing NAT64, the result is a
# link with IPv6, no IPv4, and no path to most of the internet.
nat64=$(/usr/bin/log show --last 10m --predicate 'process == "configd"' --style compact 2>/dev/null |
  grep -oE 'nat64 prefix unavailable|PREF64 prefix [0-9a-f:]+/[0-9]+' | tail -1)
print "nat64: ${nat64:-(no recent PLAT-discovery log)}"
dhcp4=$(/usr/bin/log show --last 10m --predicate 'process == "configd"' --style compact 2>/dev/null |
  grep -cE 'DHCP en0|IPv4.*en0.*(INIT|SELECT|REQUESTING|BOUND)')
print "IPv4 DHCP client events (last 10m): $dhcp4"
if [[ -z $(ipconfig getifaddr en0 2>/dev/null) && $nat64 == *unavailable* ]]; then
  print "!! IPv6-only mode with NO NAT64 -> IPv4 is unreachable by design."
  print "!! Workaround: sudo ipconfig set en0 DHCP   (forces the IPv4 client to run)"
fi
print "[dhcp options offered]"
ipconfig getpacket en0 2>/dev/null | grep -iE 'ipv6_only|option_108|108' || print "(no option 108 seen in current lease)"

print "\n=== report written to $OUT ==="
