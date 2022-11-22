source ./envcli.sh
rai --profile $RAI_CLI_PROFILE list-databases 2>/tmp/rai_cli_error.txt \
    | jq -r '.[] | [.name, ((30 - (.name | length)) * " "), "(\(.created_on))", .state] | join("  ")'

[[ $? != 0 ]] && cat /tmp/rai_cli_error.txt
