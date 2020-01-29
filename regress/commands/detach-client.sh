#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^detach-client >$TMP
echo "detach-client (detach) [-aP] [-E shell-command] [-s target-session] [-t target-client]"|cmp -s $TMP - || exit 1

# XXX
