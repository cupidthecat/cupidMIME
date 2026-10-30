#!/bin/sh
set -eu
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
printf '{"ok":true}\n' > "$tmp/wrong.png"
./build/cupidmime "$tmp/wrong.png" | grep -q 'application/json'
printf 'hello\n' | ./build/cupidmime - | grep -q 'text/plain'
./build/cupidmime -v "$tmp/wrong.png" | grep -q 'evidence=3 flags=0'
./build/cupidmime --version | grep -q '^0.1.0$'
if ./build/cupidmime "$tmp/missing" > /dev/null 2>&1; then exit 1; fi
if ./build/cupidmime > /dev/null 2>&1; then exit 1; else test "$?" -eq 2; fi
if ./build/cupidmime --bad > /dev/null 2>&1; then exit 1; else test "$?" -eq 2; fi
./build/cupidmime --help | grep -q '^Usage:'
printf 'CLI checks passed\n'
