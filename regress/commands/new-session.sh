#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^new-session >$TMP
echo "new-session (new) [-AdDEPX] [-c start-directory] [-F format] [-n window-name] [-s session-name] [-t target-session] [-x width] [-y height] [command]"|cmp -s $TMP - || exit 1

# XXX
