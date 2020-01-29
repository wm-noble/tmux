#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^save-buffer >$TMP
echo 'save-buffer (saveb) [-a] [-b buffer-name] path'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d
$TMUX setb -btwo 2
$TMUX setb -bone 1
$TMUX setb two
$TMUX setb one

$TMUX saveb - >$TMP
printf one|cmp $TMP - || exit 1

rm -f $TMP
$TMUX saveb -bone $TMP
printf 1|cmp $TMP - || exit 1
$TMUX saveb -abtwo $TMP
printf 12|cmp $TMP - || exit 1

exit 0
