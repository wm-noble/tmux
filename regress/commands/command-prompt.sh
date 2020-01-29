#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^command-prompt >$TMP
echo "command-prompt [-1kiN] [-I inputs] [-p prompts] [-t target-client] [template]"|cmp -s $TMP - || exit 1

# XXX
