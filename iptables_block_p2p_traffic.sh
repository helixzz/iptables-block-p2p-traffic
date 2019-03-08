#!/bin/bash

# Reject marked ED2K, BitTorrent traffic
iptables -t mangle -A OUTPUT -j CONNMARK --restore-mark
iptables -t mangle -A OUTPUT -m mark ! --mark 0 -j ACCEPT
iptables -t mangle -A OUTPUT -m ipp2p --edk -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m ipp2p --bit -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m ipp2p --dc -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m ipp2p --kazaa -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m ipp2p --gnu -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m mark --mark 1 -j CONNMARK --save-mark
iptables -A OUTPUT -m mark --mark 1 -j REJECT

# Log and drop URLs matches Torrent Network and DHT keywords
iptables -N LOGDROP > /dev/null 2> /dev/null
iptables -F LOGDROP
iptables -A LOGDROP -j LOG --log-prefix "LOGDROP "
iptables -A LOGDROP -j DROP
iptables -A OUTPUT -m string --algo bm --string "BitTorrent" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "BitTorrent protocol" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "peer_id=" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string ".torrent" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "announce.php?passkey=" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "torrent" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "announce" -j LOGDROP
iptables -A OUTPUT -m string --algo bm --string "info_hash" -j LOGDROP
iptables -A OUTPUT -m string --string "get_peers" --algo bm -j LOGDROP
iptables -A OUTPUT -m string --string "announce_peer" --algo bm -j LOGDROP
iptables -A OUTPUT -m string --string "find_node" --algo bm -j LOGDROP
