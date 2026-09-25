#!/bin/zsh
# Samples the Wi-Fi link + reachability once per interval into a TSV.
# Run it in a terminal and leave it; when the Wi-Fi drops, the row at that
# timestamp tells you whether the radio link died, DHCP/IP died, DNS died,
# or only the uplink beyond the router died.
#
# Caveat: on an iPhone Personal Hotspot the gateway (192.0.0.1) does not answer
# ICMP, so gw_ms reads LOSS while wan_ms is fine. A gw column of 192.0.0.1 means
# "failed over to the phone", not "the LAN is down".

INTERVAL=${1:-5}
OUT=${2:-$HOME/wifi-watch.tsv}
DURATION=${3:-0}   # seconds; 0 = run until ctrl-c
DEADLINE=0
(( DURATION > 0 )) && DEADLINE=$(( $(date +%s) + DURATION ))

# Rotated per sample so no single host sees a connect every few seconds — a
# 9-hour run against one IP looks like abuse and its rate-limiting would be
# indistinguishable from a real fault.
TCP_TARGETS=(1.1.1.1 8.8.8.8 9.9.9.9)
if [[ ! -f $OUT ]]; then
  print "time\tssid\tbssid\tchan\trssi\tnoise\ttxrate\tmcs\tip\tgw\tgw_ms\tdns_ms\twan_icmp_ms\ttcp_ms\ttcp_host" > $OUT
fi

print "logging to $OUT every ${INTERVAL}s — ctrl-c to stop"

while true; do
  ts=$(date +%H:%M:%S)

  # wdutil needs root for SSID/BSSID; system_profiler works unprivileged but is
  # slow (~1s), so prefer wdutil when we have it.
  info=$(sudo -n /usr/bin/wdutil info 2>/dev/null)
  if [[ -n $info ]]; then
    ssid=$(print -r -- "$info" | awk -F': ' '/^ *SSID/{print $2; exit}')
    bssid=$(print -r -- "$info" | awk -F': ' '/^ *BSSID/{print $2; exit}')
    chan=$(print -r -- "$info" | awk -F': ' '/^ *Channel/{print $2; exit}')
    rssi=$(print -r -- "$info" | awk -F': ' '/^ *RSSI/{print $2; exit}')
    noise=$(print -r -- "$info" | awk -F': ' '/^ *Noise/{print $2; exit}')
    txrate=$(print -r -- "$info" | awk -F': ' '/^ *Tx Rate/{print $2; exit}')
    mcs=$(print -r -- "$info" | awk -F': ' '/^ *MCS/{print $2; exit}')
  else
    sp=$(system_profiler SPAirPortDataType 2>/dev/null)
    ssid=$(print -r -- "$sp" | awk '/Current Network Information/{getline; gsub(/[ :]/,""); print; exit}')
    bssid=""
    chan=$(print -r -- "$sp" | awk -F': ' '/^ *Channel:/{print $2; exit}')
    sig=$(print -r -- "$sp" | awk -F': ' '/Signal \/ Noise/{print $2; exit}')
    rssi=${sig%% /*}; noise=${sig##*/ }
    txrate=$(print -r -- "$sp" | awk -F': ' '/Transmit Rate/{print $2; exit}')
    mcs=$(print -r -- "$sp" | awk -F': ' '/MCS Index/{print $2; exit}')
  fi

  ip=$(ipconfig getifaddr en0 2>/dev/null)
  [[ -z $ip ]] && ip="NONE"
  # Re-resolved every loop: when the Mac fails over (e.g. auto-joins the iPhone
  # hotspot) the gateway changes, and a stale one would read as pure packet loss.
  GW=$(netstat -rn -f inet | awk '$1=="default" && $NF=="en0" {print $2; exit}')

  # Three reachability layers, so a failure localises itself:
  #   gateway  = the RF link + the LAN
  #   1.1.1.1  = the uplink past the router
  #   DNS      = resolution, which fails independently of both
  rtt() { ping -c1 -W 1500 "$1" 2>/dev/null | awk -F'/' '/round-trip/{printf "%.0f", $5; f=1} END{if(!f)print "LOSS"}'; }
  gw_ms=$( [[ -n $GW ]] && rtt "$GW" || print "-" )
  wan_ms=$(rtt 1.1.1.1)
  # ICMP alone lies here: this ISP (and/or Cloudflare) deprioritises echo, which
  # showed as 24% "loss" while TCP was 15/15. tcp_ms is the trustworthy lane —
  # it is a real connect, so it cannot be rate-limited as background traffic.
  tcp_host=${TCP_TARGETS[$(( (i % ${#TCP_TARGETS[@]}) + 1 ))]}
  tcp_ms=$(curl -s -o /dev/null --connect-timeout 2 -w '%{time_connect}' \
    "https://$tcp_host" 2>/dev/null | awk '{printf "%.0f", $1*1000}')
  [[ -z $tcp_ms || $tcp_ms == 0 ]] && tcp_ms="FAIL"
  (( i++ ))
  # dig reports its own query time; zsh's `time` builtin can't be captured here.
  dns_ms=$(dig +time=2 +tries=1 apple.com 2>/dev/null | awk '/Query time:/{print $4; f=1} END{if(!f)print "FAIL"}')

  print "$ts\t$ssid\t$bssid\t$chan\t$rssi\t$noise\t$txrate\t$mcs\t$ip\t$GW\t$gw_ms\t$dns_ms\t$wan_ms\t$tcp_ms\t$tcp_host" >> $OUT
  print "$ts rssi=$rssi tx=$txrate gw=$gw_ms tcp=$tcp_ms($tcp_host) dns=$dns_ms wan_icmp=$wan_ms"

  if (( DEADLINE > 0 )) && (( $(date +%s) >= DEADLINE )); then
    print "duration reached — stopping"
    break
  fi
  sleep "$INTERVAL"
done
