source ./envcli.sh
rai --profile $RAI_CLI_PROFILE list-users 2>/tmp/rai_cli_error.txt \
    | jq -r '.[] | [.email, ((32 - (.email | length)) * " "), .roles[], ((5 - (.roles[] | length)) * " "), .status, "(\([.id_providers[]] | join(",")))"] | join("  ")'

[[ $? != 0 ]] && cat /tmp/rai_cli_error.txt
