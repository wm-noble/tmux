#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^swap-pane >$TMP
echo "swap-pane (swapp) [-dDUZ] [-s src-pane] [-t dst-pane]"|cmp -s $TMP - || exit 1

# XXX
