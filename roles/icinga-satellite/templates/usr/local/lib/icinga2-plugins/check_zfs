#!/usr/bin/env bash
# Based on:
# Script by Marianne M. Spiller <marianne.spiller@dfki.de>
# 20180627 - print dataset and filesystem stats when -d is not given
# 20180118 - initial commit
# Source: https://github.com/netzwerkgoettin/icinga2-plugin-zfsstats
# With changes to ignore quotas, and calculate free space using the total zpool available space instead.

PROG=`basename $0`
##---- Defining Icinga 2 exit states
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

##---- Ensure we're using GNU tools
DATE=$({ which gdate || which date; } | tail -1)
GREP=$({ which ggrep || which grep; } | tail -1)
WC=$({ which gwc || which wc; } | tail -1)

read -d '' USAGE <<- _EOF_
$PROG - list all available datasets, filesystem and print usage instructions
$PROG [ -c <critical_space> ] [ -w <warning_space> ] -d <dataset>
  -c : Optional: CRITICAL space left for dataset (default: 5%)
  -d : dataset to check
  -w : Optional: WARNING space left for dataset (default: 10%)
_EOF_

_usage() {
  echo "==== USAGE ===="
  echo "$USAGE"
  exit $STATE_WARNING
}

_getopts() {
  while getopts 'c:d:hw:' OPT ; do
    case $OPT in
      c)
        CRITICAL_PERCENT="$OPTARG"
        ;;
      d)
        ZFS_DATASET="$OPTARG"
        ;;
      h)
        _usage
        ;;
      w)
        WARNING_PERCENT="$OPTARG"
        ;;
      *) echo "Invalid option --$OPTARG1"
        _usage
        ;;
    esac
  done
}

_performance_data() {
cat <<- _EOF_
| used=$USED; available=$AVAIL; total=$TOTAL;
_EOF_
}

_print_stats() {
  echo "==== ZFS DATASETS ===="
  zpool list
  echo " "
  echo "==== ZFS FILESYSTEMS ===="
  zfs list -t filesystem
  echo " "
}

_getopts $@

if [ -z "$ZFS_DATASET" ] ; then
  ## We're missing a dataset, so we'll print the stats
  _print_stats
  _usage
fi

if ! zfs list $ZFS_DATASET > /dev/null 2>&1; then
  echo "'$ZFS_DATASET' is not a ZFS dataset - try $PROG without any parameter to get a list of valid datasets!"
  exit $STATE_UNKNOWN
fi

if [ -z "$WARNING_PERCENT" ] ; then
  ## Default: 10%
  WARNING_PERCENT="10"
fi

if [ -z "$CRITICAL_PERCENT" ] ; then
  ## Default: 5%
  CRITICAL_PERCENT="5"
fi

# Total size available in pool
TOTAL=`zpool list -Hp -o size $ZFS_DATASET`
TOTAL_READABLE=`zpool list -H -o size $ZFS_DATASET`

USED=`zfs list -Hp -o used $ZFS_DATASET`
USED_READABLE=`zfs list -H -o used $ZFS_DATASET`
AVAIL=`zfs list -Hp -o avail $ZFS_DATASET`
AVAIL_READABLE=`zfs list -H -o avail $ZFS_DATASET`
REFER=`zfs list -Hp -o refer $ZFS_DATASET`

AVAIL_PERCENT=$(( $AVAIL*100/$TOTAL|bc -l ))
WARNING_VALUE=$(( $USED*$WARNING_PERCENT/100|bc -l ))
CRITICAL_VALUE=$(( $USED*$CRITICAL_PERCENT/100|bc -l ))

##----------- Informational output follows
if [ "$AVAIL_PERCENT" -lt "$CRITICAL_PERCENT" ] ; then
  echo -n "CRITICAL: only $AVAIL_PERCENT% ($AVAIL_READABLE) available on $ZFS_DATASET "
  _performance_data
  exit $STATE_CRITICAL
elif [ "$AVAIL_PERCENT" -lt "$WARNING_PERCENT" ] ; then
  echo -n "WARNING: only $AVAIL_PERCENT% ($AVAIL_READABLE) available on $ZFS_DATASET "
  _performance_data
  exit $STATE_WARNING
else 
  echo -n "OK: $AVAIL_PERCENT% ($AVAIL_READABLE) available on $ZFS_DATASET "
  _performance_data
  exit $STATE_OK
fi
