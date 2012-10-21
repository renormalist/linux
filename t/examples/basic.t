#!/bin/bash

############################################################
#
# t/examples/basic.t
#
# An example test script for bash-test-utils
#
# Run it with:
#
#   $ cd $LINUX_SRC_DIR
#   $ prove -v t/examples/basic.t
#
############################################################

. ./tools/testing/tap/bash-test-utils

uname -a | grep -q Linux  # example for ok exit code
ok $? "we run on Linux"

# require_* functions gracefully exit if requirements not met
require_cpufeature "msr"
require_cpufeature "fpu"

# store success in variables and make complex tests
if grep -q sse2 /proc/cpuinfo ; then
    success=0
else
    success=1
fi

# ok() evaluates arg 1 with exit code shell boolean semantics
# and creates TAP
ok $success "SSE2 in cpuinfo"

# negate_ok() reverses the success semantics of ok()
grep -q impossible-value /proc/cpuinfo
negate_ok $? "no impossible-value in cpuinfo"

# mark tests with "# TODO" at end of description
# for test driven development
grep -q not-yet-implemented-detail /proc/cpuinfo
ok $? "example that fails expectedly # TODO some todo explanation"

# append key:value lines to track values
bogomips=$(grep -i bogomips /proc/cpuinfo | head -1 | cut -d: -f2)
append_tapdata "bogomips: $(echo ${bogomips:-0.0})"

done_testing
