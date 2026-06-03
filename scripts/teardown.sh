#!/bin/sh

exec "$(cd "$(dirname "$0")" && pwd)/setup.sh" --down "$@"
