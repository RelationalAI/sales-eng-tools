source ./envcli.sh
pro=$RAI_CLI_PROFILE
db=$RAI_CLI_DATABASE
eng=$RAI_CLI_ENGINE

rai --profile $pro --engine $eng list-edb-names $db --quiet --format json \
    | jq -r '.[]' \
    | grep -v -e "^debug$" -e "^rel$" -e "^relconfig$" -e rel_primitive_transaction_edb \
    | sort
