#!/bin/sh

#########################################################
# Display the status of the Babel mesh network.
# Latest version: https://gist.github.com/gists/3547685
#
# Usage:
# babelstatus.sh : shows babel routes
# babelstatus.sh --full : show other relevant info
#
# If you add your link-local addresses to your /etc/hosts
# you will get a more readable output.
#########################################################

# Detect the port used by Babel
BABELDPORT=`uci get babeld.@general[0].local_port`

if [ "$BABELDPORT" = "" ]; then
  BABELDPORT=33123
fi

# Complicated awk script (because Perl is hard to install on OpenWRT)
AWK='
function get_hostname_from_ip(ip) {
  result = ip " [unknown]";
  command = "grep " ip " /etc/hosts";

  command | getline result;
  close(command);

  return result;
}
function get_neighbour(str) {
  start = match(str, "via ([^ ]*)");
  ip = substr(str, start + 4, RLENGTH - 4);
  host = get_hostname_from_ip(ip);
  return host;
}
function strskip(str, skip) {
  start = match(str, "(" skip ")");
  return substr(str, start + RLENGTH);
}
BEGIN {
  neighstarted=0;
  exportstarted=0;
}
{
  if (/^BABEL 0/) {
  }
  else if (/^add self alamakota id/) {
    print "My MAC ID: ", $5;
  }
  else if (/^add neighbour/) {
    if (! neighstarted) {
      print "*** Neighbours ***";
      neighstarted=1;
    }
    ip = $5;
    host = get_hostname_from_ip(ip);
    print host strskip($0, "add neighbour [0-9a-zA-Z]+ address [^ ]+");
  }
  else if (/^add xroute/) {
    if (! exportstarted) {
      print "*** Exported routes ***";
      exportstarted=1
    }
    print strskip($0, "add xroute ");
  }
  else if (/installed yes/) {
    neigh = get_neighbour($0);
    a[neigh] = a[neigh] "\n    " strskip($0, "add route ");
  }
  else if (/installed no/) {
    if (FULL) {
      neigh = get_neighbour($0);
      a[neigh] = a[neigh] "\n    [alt] " strskip($0, "add route ");
    }
  }
  else {
    print;
  }
}
END {
  if (length(a)) {
    print "*** Routes ***";
    for(i in a) {
      print i " -> " a[i]
    }
  }
}
'

nc :: $BABELDPORT | awk '{ if (/^add/ || /^BABEL/) { print } else { exit } }' | awk -v FULL=$1 "$AWK"

if [ "$1" == "--full" ]; then
  echo "*** IPv6 routing table (ip -6 route) ***"
  ip -6 route

  echo "*** IPv4 routing table (ip -4 route)***"
  ip -4 route

  echo "*** ifconfig -a ***"
  ifconfig -a
fi

