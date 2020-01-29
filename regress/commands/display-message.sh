#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^display-message >$TMP
echo 'display-message (display) [-aIpv] [-c target-client] [-F format] [-t target-pane] [message]'|cmp -s $TMP - || exit

$TMUX new -d \; splitw -d ''

$TMUX display -p '#{pane_id}' >$TMP
echo '%0'|cmp $TMP - || exit 1
$TMUX display -pt%1 '#{pane_id}' >$TMP
echo '%1'|cmp $TMP - || exit 1

$TMUX display -p -F '#{pane_id}' >$TMP
echo '%0'|cmp $TMP - || exit 1
$TMUX display -pt%1 -F '#{pane_id}' >$TMP
echo '%1'|cmp $TMP - || exit 1

$TMUX display -p -v '#{pane_id}' >$TMP
cat <<EOF|cmp -s $TMP - || exit 1
# expanding format: #{pane_id}
# found #{}: pane_id
# format 'pane_id' found: %0
# replaced 'pane_id' with '%0'
# result is: %0
%0
EOF

$TMUX display -ap|grep ^pane_id >$TMP
echo 'pane_id=%0'|cmp $TMP - || exit 1
$TMUX display -apt%1|grep ^pane_id >$TMP
echo 'pane_id=%1'|cmp $TMP - || exit 1

echo foobar|$TMUX display -It%1
$TMUX capturep -pt%1|sed '/^$/d' >$TMP
echo foobar|cmp $TMP - || exit 1

exit 0
