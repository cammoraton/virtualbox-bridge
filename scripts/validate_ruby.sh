#!/bin/bash -ex

readonly RUBY=$(command -v ruby)
readonly GEM=$(command -v gem)

ERRORS=0

# Validate binaries are installed and available to the
# current path.
if [ ! -n "${RUBY}" ]; then
  (>&2 echo "ERROR: ruby command not installed or not in path")
  (>&2 echo "       please install ruby and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${GEM}" ]; then
  (>&2 echo "ERROR: gem command not installed or not in path")
  (>&2 echo "       please install rubygems and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ${ERRORS} -eq 1 ]; then
  exit 1
fi
