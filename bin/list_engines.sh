source ./envcli.sh
rai --profile $RAI_CLI_PROFILE list-engines 2>/tmp/rai_cli_error.txt \
    | jq -r '.[] | [.name, ((30 - (.name | length)) * " "), "(\(.size), \(.created_on))", .state] | join("  ")' \
    | grep --color=NEVER -e PROVISIONED -e PROVISIONING

[[ $? != 0 ]] && cat /tmp/rai_cli_error.txt
