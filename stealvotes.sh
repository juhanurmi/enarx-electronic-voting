#!/bin/bash

# Usage
if [ $# != 1 ] ; then
    echo "Usage: $0 processname" >&2
    exit 1
fi

# Find the PID
if ! pid=`pgrep -f -o $1` ; then
    echo "Unable to find PID for ${1}" >&2
    exit 1
fi

# Do not use pid of this script
if [[ "$$" == "$pid" ]] ; then
  echo "Unable to find PID for ${1}" >&2
  exit 1
fi

python3 manipulate.py $pid
