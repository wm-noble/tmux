#!/bin/sh

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

TMP=$(mktemp)
trap "rm -f $TMP" 0 1 15

$TMUX lscm|grep ^bind-key >$TMP
echo "bind-key (bind) [-nr] [-T key-table] [-N note] key command [arguments]"|cmp -s $TMP - || exit 1

$TMUX -f/dev/null new -d
$TMUX bind -n X rename foo
$TMUX lsk -Troot X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -T root X rename-session foo
EOF
$TMUX unbind -n X

$TMUX bind -Troot X rename foo
$TMUX lsk -Troot X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -T root X rename-session foo
EOF
$TMUX unbind -Troot X

$TMUX bind X rename foo
$TMUX lsk -Tprefix X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -T prefix X rename-session foo
EOF
$TMUX unbind -Tprefix X

$TMUX bind -Tprefix X rename foo
$TMUX lsk -Tprefix X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -T prefix X rename-session foo
EOF
$TMUX unbind -Tprefix X

$TMUX bind -Tnewtable X rename foo
$TMUX lsk -Tnewtable X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -T newtable X rename-session foo
EOF
$TMUX unbind -Tnewtable X

$TMUX bind -r X rename foo
$TMUX lsk -Tprefix X >$TMP
cat <<EOF|cmp $TMP - || exit 1
bind-key -r -T prefix X rename-session foo
EOF
$TMUX unbind -Tprefix X

$TMUX bind -Nbar X rename foo
$TMUX lsk -NTprefix X >$TMP
cat <<EOF|cmp $TMP - || exit 1
X bar
EOF
$TMUX unbind X

exit 0
