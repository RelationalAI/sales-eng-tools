# delete specified engine
# if none specified, delete default engine from envcli.sh

source ./envcli.sh

pro=$RAI_CLI_PROFILE
# db=$RAI_CLI_DATABASE
eng=$1
[[ "$eng" == "" ]] && eng=$RAI_CLI_ENGINE

eng_info=`rai --profile $pro get-engine $eng --quiet`
if [[ "$eng_info" == "" ]]; then
    echo "engine '$eng' not running"
else
    set -e
    # echo "deleting '$eng' ..."
    rai --profile $pro delete-engine $eng
fi
