# load specified model source into the specified DB

source ./envcli.sh
pro=$RAI_CLI_PROFILE
db=$RAI_CLI_DATABASE
eng=$RAI_CLI_ENGINE
old_parent=$RAI_SE_UTIL_OLD_PARENT
new_parent=$RAI_SE_UTIL_NEW_PARENT

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
    if [[ "$old_parent" == "" ]]; then          # this test must come first
        model=$rel
    elif [[ $rel =~ ${old_parent}.* ]]; then    # reparent if there's a match
        model="${new_parent}/${rel#${old_parent}}"
    else                                        # otherwise install as-is
        model=$rel
    fi
    # echo "installing '$rel' as '$model' into database '$db'"
    rai --profile $pro --engine $eng load-model $db $rel --model $model
done
