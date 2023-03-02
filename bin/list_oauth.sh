source ./envcli.sh
rai --profile $RAI_CLI_PROFILE list-oauth-clients 2>/tmp/rai_cli_error.txt \
    | jq -r '.[] | [.name, ((20 - (.name | length)) * " "), .id, .created_on] | join("  ")'

[[ $? != 0 ]] && cat /tmp/rai_cli_error.txt
