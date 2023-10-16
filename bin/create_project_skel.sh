
[ $# != 2 ] && echo "usage: $0 <base> <appname>" && exit 13

# run this from the customer directory
# for example:
# cd ~/src/rai/sales-engineering/<customer>
# create_project_skel.sh poc1 tearsheet

BASE=$1
APPNAME=$2

mkdir -pv $BASE/$APPNAME/{model,util,viz,constraint}
mkdir -pv $BASE/{bin,orm,query,update,test,test_log,sample_data,snowflake}
