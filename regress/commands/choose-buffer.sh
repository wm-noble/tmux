#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^choose-buffer >$TMP
echo "choose-buffer [-NrZ] [-F format] [-f filter] [-O sort-order] [-t target-pane] [template]"|cmp -s $TMP - || exit 1

# XXX
