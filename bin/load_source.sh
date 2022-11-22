# load specified model source into the specified DB

source ./envcli.sh
pro=$RAI_CLI_PROFILE
db=$RAI_CLI_DATABASE
eng=$RAI_CLI_ENGINE

# set -x

db_arg=$1
if [[ "$db_arg" == "--db" ]]; then
    db=$2
    shift
    shift
fi

list=$@
[[ "$list" = "" ]] && echo "usage: $0 [--db db-name] rel-name|rel-list" && exit 13

set -e

for rel in $list; do
    echo "installing '$rel' into database '$db'"
    rai --profile $pro --engine $eng load-model $db $rel --model $rel
done
