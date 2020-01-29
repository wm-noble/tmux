#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^clear-history >$TMP
echo 'clear-history (clearhist) [-t target-pane]'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d -x 5 -y 5 'printf "0\n1\n2\n3\n4\n5\n\6"; sleep 10'
L=$($TMUX -f/dev/null display -p '#{history_size}')
[ $L -eq 2 ] || exit 1
$TMUX clear-history
L=$($TMUX -f/dev/null display -p '#{history_size}')
[ $L -eq 0 ] || exit 1

exit 0
