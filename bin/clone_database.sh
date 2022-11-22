# clone existing DB to create new DB
## Note:
## The semantics of the RAI operation is "create clone from source".
## But the semantics of this script is "clone source to destination", like Linux cp, mv, etc.

source ./envcli.sh
pro=$RAI_CLI_PROFILE
eng=$RAI_CLI_ENGINE

# set -x

[ $# != 2 ] && echo "usage: $0 source-db-name clone-db-name" && exit 13
source_db=$1
clone_db=$2

set -e

rai --profile $pro clone-database $clone_db $source_db
# workaround system bug where newly cloned database "not finished" until an engine runs something on it
rai --profile $pro --engine $eng exec $clone_db --code '''def output="touched by an engine"'''
