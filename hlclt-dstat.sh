#!/bin/bash
#

_dstatname="$(date +%F_%H%M)-hlclt-dstat"

function _help() {
    echo
    echo "${BASH_SOURCE[0]} [-h ] [name]"
    echo "  Show dstat system statistics for HL performance client and write to log and csv file."
    echo "  Parameters:"
    echo "    name - test name, files will be <name>.log and <name>.csv"
    echo "           (optional, default: $_dstatname)"
    echo "  Options:"
    echo "     -h, -?           : display this help message."
    echo
}

# Parse options upfront
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?:" opt; do
  case "$opt" in
      h|\?)
        _help
        exit 0
        ;;
  esac
done

case $# in
    0)  # use default test name
        test_name=$_dstatname
        ;;
    1)
        test_name=$1
        ;;
    *)
        echo "Invalid number parameters - expected 0 or 1"
        _help
        exit 3
        ;;
esac

which "dstat" > /dev/null
_rc=$?
if [ $_rc -ne 0 ]; then
  echo "Required tool \"dstat\" to show system stats is not installed, cannot proceed - aborting."
  exit -1
fi

echo "Showing system statistics for test server during performance test"
echo "and logging them to <${test_name}.csv> and <${test_name}.log> - press CTRL-C to end..."
echo
dstat -cimn --socket --tcp  --output ${test_name}.csv 2  | tee ${test_name}.log

# need to get interrupted
