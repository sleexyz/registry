#!/bin/sh
set -e
cd "$(dirname "$0")"
./lint.sh && stack test
