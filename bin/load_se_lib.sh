# load SE Library source into the specified DB

source ./envcli.sh
pro=$RAI_CLI_PROFILE
db=$RAI_CLI_DATABASE
eng=$RAI_CLI_ENGINE
seutils_dir=$RAI_SE_UTIL_DIR

# set -x

db_arg=$1
if [[ "$db_arg" == "--db" ]]; then
    db=$2
    shift
    shift
fi

set -e

# install SE utils
echo "Installing se_lib ..."
list=`find $seutils_dir/se_lib -type f -name "*.rel"`

for rel in $list; do
    model=${rel#$seutils_dir/}
    rai --profile $pro --engine $eng load-model $db $rel --model $model
done
