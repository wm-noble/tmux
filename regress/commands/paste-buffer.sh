#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^paste-buffer >$TMP
echo "paste-buffer (pasteb) [-dpr] [-s separator] [-b buffer-name] [-t target-pane]"|cmp -s $TMP - || exit 1

# XXX
