#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^split-window >$TMP
echo "split-window (splitw) [-bdefhIPv] [-c start-directory] [-e environment] [-F format] [-l size] [-t target-pane] [command]"|cmp -s $TMP - || exit 1

# XXX
