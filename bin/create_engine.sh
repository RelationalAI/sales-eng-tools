# create specified engine
# if none specified, create default engine from envcli.sh

source ./envcli.sh

pro=$RAI_CLI_PROFILE
# db=$RAI_CLI_DATABASE
eng=$1
[[ "$eng" == "" ]] && eng=$RAI_CLI_ENGINE

regex="^.*\-(XS|S|M|L|XL)$"
[[ "$eng" =~ $regex ]]
eng_size="${BASH_REMATCH[1]}"
[[ "$eng_size" == "" ]] && eng_size=XS

eng_info=`rai --profile $pro get-engine $eng --quiet`
if [[ "$eng_info" == "" ]]; then
    set -e
    # echo "creating '$eng', size '$eng_size' ..."
    rai --profile $pro create-engine $eng --size $eng_size
else
    echo "engine '$eng' already running"
fi
