#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^rotate-window >$TMP
echo 'rotate-window (rotatew) [-DUZ] [-t target-window]'|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d \; splitw -d \; splitw -d
$TMUX -f/dev/null neww   \; splitw -d \; splitw -d

for i in 0 1 2 3 4 5; do
	$TMUX selectp -t%$i -T$i
done

$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %0 0
@0 %2 2
@0 %1 1
@1 %3 3
@1 %5 5
@1 %4 4
EOF

$TMUX rotatew -Ut@0 || exit 1
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %2 2
@0 %1 1
@0 %0 0
@1 %3 3
@1 %5 5
@1 %4 4
EOF

$TMUX rotatew -Dt@0 || exit 1
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %0 0
@0 %2 2
@0 %1 1
@1 %3 3
@1 %5 5
@1 %4 4
EOF

$TMUX rotatew -U || exit 1
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %0 0
@0 %2 2
@0 %1 1
@1 %5 5
@1 %4 4
@1 %3 3
EOF

$TMUX rotatew -D || exit 1
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %0 0
@0 %2 2
@0 %1 1
@1 %3 3
@1 %5 5
@1 %4 4
EOF

$TMUX resizep -Zt%0 || exit 1
$TMUX lsw -F '#{window_id} #{window_zoomed_flag}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 1
@1 0
EOF
$TMUX rotatew -t@0 || exit 1
$TMUX lsw -F '#{window_id} #{window_zoomed_flag}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 0
@1 0
EOF
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %2 2
@0 %1 1
@0 %0 0
@1 %3 3
@1 %5 5
@1 %4 4
EOF

$TMUX resizep -Zt%0 || exit 1
$TMUX lsw -F '#{window_id} #{window_zoomed_flag}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 1
@1 0
EOF
$TMUX rotatew -Zt@0 || exit 1
$TMUX lsw -F '#{window_id} #{window_zoomed_flag}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 1
@1 0
EOF
$TMUX lsp -aF '#{window_id} #{pane_id} #{pane_title}' >$TMP
cat <<EOF|cmp $TMP - || exit 1
@0 %1 1
@0 %0 0
@0 %2 2
@1 %3 3
@1 %5 5
@1 %4 4
EOF

exit 0
