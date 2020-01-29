#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^rename-window >$TMP
echo 'rename-window (renamew) [-t target-window] new-name'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -dnone \; neww -dntwo
$TMUX renamew oneone
$TMUX renamew -t:two twotwo
$TMUX lsw -F '#{window_id} #{window_name}' >$TMP
cat <<EOF|cmp -s $TMP -
@0 oneone
@1 twotwo
EOF

exit 0
