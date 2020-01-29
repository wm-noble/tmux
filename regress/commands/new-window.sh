#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^new-window >$TMP
echo "new-window (neww) [-adkP] [-c start-directory] [-e environment] [-F format] [-n window-name] [-t target-window] [command]"|cmp -s $TMP - || exit 1

# XXX
