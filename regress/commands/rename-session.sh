#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^rename-session >$TMP
echo 'rename-session (rename) [-t target-session] new-name'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -dsone \; new -dstwo
$TMUX rename twotwo
$TMUX rename -tone: oneone
$TMUX ls -F '#{session_id} #{session_name}' >$TMP
cat <<EOF|cmp -s $TMP - || exit
$0 oneone
$1 twotwo
EOF

exit 0
