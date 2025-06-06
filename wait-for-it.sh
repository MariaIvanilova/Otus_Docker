#!/bin/sh
set -e

host="$1"
port="$2"
shift 2
cmd="$@"

# Таймаут в секундах (по умолчанию 60)
timeout=60
for arg in "$@"; do
  case "$arg" in
    --timeout=*)
      timeout="${arg#*=}"
      shift
      ;;
    --timeout)
      timeout="$2"
      shift 2
      ;;
  esac
done

end=$((SECONDS+timeout))

while ! nc -z "$host" "$port"; do
  if [ $SECONDS -ge $end ]; then
    >&2 echo "Timeout reached waiting for $host:$port"
    exit 1
  fi
  >&2 echo "Waiting for $host:$port..."
  sleep 1
done

>&2 echo "$host:$port is available, executing command: $cmd"
exec $cmd