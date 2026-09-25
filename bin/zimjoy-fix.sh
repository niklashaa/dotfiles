#!/bin/zsh
# Force the IPv4 DHCP client on en0, but only when actually on ZIM Joy — the
# same command on the iPhone hotspot is a silent no-op (that link is genuinely
# IPv6-only with CLAT46, so there is no DHCPv4 server to answer).
#
#   sudo ~/bin/zimjoy-fix.sh
#
# Distinguishes the networks by IPv6 prefix, since macOS hides the SSID from
# `networksetup` when a private MAC is in use:
#   ZIM Joy  -> 2a02:908:...   (Vodafone cable)
#   hotspot  -> 2a01:599:...   (mobile) + a clat46 address

v6=$(ifconfig en0 | awk '/inet6 2a/ {print $2; exit}')
clat=$(ifconfig en0 | grep -c clat46)

if (( clat > 0 )) || [[ $v6 == 2a01:599:* ]]; then
  print "en0 is on the iPhone hotspot ($v6) — not ZIM Joy."
  print "Join ++ZIM++Joy first; this command does nothing here."
  exit 1
fi
if [[ $v6 != 2a02:908:* ]]; then
  print "en0 is on an unrecognised network (v6=${v6:-none}). Continuing anyway."
fi

if [[ $(id -u) -ne 0 ]]; then
  print "needs root: sudo $0"
  exit 1
fi

print "before: ip=$(ipconfig getifaddr en0 2>/dev/null || print NONE)"
ipconfig set en0 DHCP
print "forcing DHCPv4 ..."

for i in {1..15}; do
  sleep 1
  ip=$(ipconfig getifaddr en0 2>/dev/null)
  [[ -n $ip ]] && break
done

if [[ -n $ip ]]; then
  print "OK: got $ip after ${i}s"
  print "gateway: $(netstat -rn -f inet | awk '$1=="default" && $NF=="en0"{print $2;exit}')"
  print "\n[lease options — looking for option 108 'IPv6-Only Preferred']"
  # This is the evidence that settles whether the network is telling the Mac to
  # abandon IPv4. Worth capturing every time a lease is obtained.
  ipconfig getpacket en0 2>/dev/null | grep -iE 'ipv6_only|108|yiaddr|router|lease_time'
else
  print "FAILED: still no IPv4 lease after 15s — the DHCP server did not answer."
  print "nat64 state:"
  /usr/bin/log show --last 3m --predicate 'process == "configd"' --style compact 2>/dev/null |
    grep -oE 'nat64 prefix unavailable|PREF64 prefix [^ ]+' | tail -2
fi
