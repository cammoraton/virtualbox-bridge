#!/bin/bash -ex

readonly PYTHON3=$(command -v python3)
readonly VIRTUALENV=$(command -v virtualenv)
readonly PIP=$(command -v pip)

ERRORS=0

# Validate binaries are installed and available to the
# current path.
if [ ! -n "${PYTHON3}" ]; then
  (>&2 echo "ERROR: python3 command not installed or not in path")
  (>&2 echo "       please install python3 and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${VIRTUALENV}" ]; then
  (>&2 echo "ERROR: virtualenv command not installed or not in path")
  (>&2 echo "       please install python-virtualenv and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${PIP}" ]; then
  (>&2 echo "ERROR: pip command not installed or not in path")
  (>&2 echo "       please install python-pip and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ${ERRORS} -eq 1 ]; then
  exit 1
fi
