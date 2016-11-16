#!/usr/bin/env bash
#
# Check memory usage
#
# Usage: check_memory.sh [-w warning] [-c critical]
#     -w, --warning WARNING         Warning value (percent)
#     -c, --critical CRITICAL       Critical value (percent)
#     -h, --help                    Display this screen
#
# (c) 2014, Benjamin Dos Santos <benjamin.dossantos@gmail.com>
# https://github.com/bdossantos/nagios-plugins
#

while [[ -n "$1" ]]; do
  case $1 in
    --warning|-w)
      warn=$2
      shift
      ;;
    --critical|-c)
      crit=$2
      shift
      ;;
    --help|-h)
      sed -n '2,9p' "$0" | tr -d '#'
      exit 3
      ;;
    *)
      echo "Unknown argument: $1"
      exec "$0" --help
      exit 3
      ;;
  esac
  shift
done

warn=${warn:=90}
crit=${crit:=95}

memory_total=$(free | fgrep 'Mem:' | awk '{print $2}')
memory_used=$(free | fgrep '/+ buffers/cache' | awk '{print $3}')
memory_free=$((memory_total - memory_used))
memory_free_human=$((memory_free / 1024))
percentage=$((memory_used * 100 / memory_total))

# MEMORY OK - 2765M free | free=2899427328b;;

status="${percentage}% ${memory_free_human}M free | free=${memory_free}b;;";

if [[ -z $percentage ]]; then
  echo "MEMORY UNKNOWN - Error"
  exit 3
elif [[ $percentage -gt $crit ]]; then
  echo "MEMORY CRITICAL - ${status}"
  exit 2
elif [[ $percentage -gt $warn ]]; then
  echo "MEMORY WARNING - ${status}"
  exit 1
else
  echo "MEMORY OK - ${status}"
  exit 0
fi
