#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^kill-server >$TMP
echo 'kill-server '|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d
$TMUX has || exit 1
$TMUX kill-server
$TMUX has 2>/dev/null && exit 1

exit 0
