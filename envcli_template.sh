# Template version of envcli.sh

# Copy this template and customize your own version as "envcli.sh"
# (and don't check it in!). Then source envcli.sh in each "rai" CLI script
# to set environment variables for your work.
# e.g. source ./envcli.sh

# Using envcli.sh and these RAI_CLI_* variables allows multiple Sales Engineers
# to work across multiple accounts, with different DBs and engines,
# while sharing the same scripts.

# N.B., uses pre-existing environment variables, RAI_PROFILE and RAI_ENGINE,
# to accomodate the setup used by Martin and others in R&D who share
# a single RAI account with separate engines.

RAI_CLI_DATABASE=your-database

if [ -z "$RAI_PROFILE" ]; then
    RAI_CLI_PROFILE=your-account
else
    RAI_CLI_PROFILE="$RAI_PROFILE"
fi

if [ -z "$RAI_ENGINE" ]; then
    # e.g. ${USER}-`date "+%Y%m%d"`-S
    RAI_CLI_ENGINE=your-engine
else
    RAI_CLI_ENGINE="$RAI_ENGINE"
fi

# R&D uses Linux's GNU "time", but Mac's zsh built-in "time" is very primitive.
# For Mac we use GNU-time (gtime) from homebrew: brew install gnu-time
if [[ `which gtime` =~ "not found" ]]; then
    RAI_CLI_TIME=time
else
    RAI_CLI_TIME=gtime
fi

# Basic Workloads Benchmarking framework, "RAI BENCH"
RAI_BENCH_DIR=your-directory

# RAI Sales Engineering utilities
RAI_SE_UTIL_DIR=~/....../common

# Diffbot token (personal token for user)
DIFFBOT_TOKEN=......
