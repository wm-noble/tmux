#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^list-buffers >$TMP
echo 'list-buffers (lsb) [-F format]'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d
$TMUX setb one
$TMUX setb two
$TMUX setb -bone 1
$TMUX setb -btwo 2

$TMUX lsb >$TMP
cmp -s $TMP - <<EOF || exit 1
two: 1 bytes: "2"
one: 1 bytes: "1"
buffer1: 3 bytes: "two"
buffer0: 3 bytes: "one"
EOF

$TMUX lsb -F '#{buffer_name} #{buffer_size} #{s|[0-9]|x|r:buffer_created}' >$TMP
cmp -s $TMP - <<EOF || exit 1
two 1 xxxxxxxxxx
one 1 xxxxxxxxxx
buffer1 3 xxxxxxxxxx
buffer0 3 xxxxxxxxxx
EOF

exit 0
