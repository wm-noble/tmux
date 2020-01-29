#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^has-session >$TMP
echo 'has-session (has) [-t target-session]'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -dsone 'sleep 10'
$TMUX -f/dev/null new -dsonetwo 'sleep 10'

$TMUX has-session || exit 1

$TMUX has-session -t=one: || exit 1
$TMUX has-session -t=onetwo: || exit 1

$TMUX has-session -t=one || exit 1
$TMUX has-session -t=onetwo || exit 1

$TMUX has-session -tone || exit 1
$TMUX has-session -tonetwo || exit 1

$TMUX has-session -t '@0' || exit 1
$TMUX has-session -t '%0' || exit 1
$TMUX has-session -t '$0' || exit 1

$TMUX has-session -tonet || exit 1
$TMUX has-session -tonet: || exit 1
$TMUX has-session -t=onet 2>/dev/null && exit 1
$TMUX has-session -t=onet: 2>/dev/null && exit 1

$TMUX has-session -tthree 2>/dev/null && exit 1
$TMUX has-session -tthree: 2>/dev/null && exit 1
$TMUX has-session -t=three 2>/dev/null && exit 1
$TMUX has-session -t=three: 2>/dev/null && exit 1

$TMUX has-session -t '@2' 2>/dev/null && exit 1
$TMUX has-session -t '%2' 2>/dev/null && exit 1
$TMUX has-session -t '$2' 2>/dev/null && exit 1

exit 0
