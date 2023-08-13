# create specified user
# if no role specified, make a "regular" (not-Admin) user

source ./envcli.sh
pro=$RAI_CLI_PROFILE

[[ $# < 1 ]] && echo "usage: $0 email [user|admin|user-read-only]" && exit 13
email=$1
role=$2
[[ "$role" == "" ]] && role="user"
if [[ "$role" =~ ^(user|admin|user-read-only)$ ]]; then
    echo "creating user '$email' with role '$role'"
    rai --profile $pro create-user $email --role $role
else
    echo "usage: role must be 'user' or 'admin'" && exit 13
fi
