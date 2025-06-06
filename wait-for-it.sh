#!/bin/sh
set -e

host="$1"
port="$2"
timeout="$4"
shift 2
cmd="$@"

until nc -z "$host" "$port"; do
  >&2 echo "Waiting for $host:$port to become available..."
  sleep 1
done

>&2 echo "$host:$port is available, executing command: $cmd"
exec $cmd