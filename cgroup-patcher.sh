#!/bin/bash
 
if ! grep -q cgroup2 /proc/filesystems; then
    echo "error: cgroupv2 is not supported"
    exit 1
else
    echo "cgroup V2 found"
fi

kernelarg='systemd.unified_cgroup_hierarchy=1'
f=/etc/default/grub
if [ ! -f $f ]; then
    echo "error: cannot find grub default file"
    exit 1
fi

cmd=awk
if ! command -v ${cmd} >/dev/null ; then
    echo "error: command ${cmd} not found"
    exit 1
fi

set -e

tmpfile=/tmp/awk-repl-$RANDOM
awk -F\" -v karg=${kernelarg} '
/GRUB_CMDLINE_LINUX=/          { print "GRUB_CMDLINE_LINUX=\"" $2 " " karg "\""; next; }
                               { print ; }
' >${tmpfile}

chmod 644 ${tmpfile}
mv ${tmpfile} $f
rm -f ${tmpfile}

set +e
