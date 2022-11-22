# summarize the JSON output from a RAI_BENCH run

source ./envcli.sh
# echo "using $RAI_BENCH_DIR/output"
set -e
# set -x

dbg=0
if [[ "$1" == "-d" ]]; then
    dbg=1
    shift
fi

if [[ $dbg == 1 ]]; then
    jq_pgm='.benchmark_name, .query_name, (["eng:", ([.engine.name, .engine.size] | join(", "))] | join(" ")), (["mean:", .mean] | join(" ")), (.runs |[ .[] | .timed | .duration_s, (["-- ", .transaction_id, ", ", .start_time, ", ", .datadog_logs] | add) ], "-------------")'
else
    jq_pgm='.benchmark_name, .query_name, (["eng:", ([.engine.name, .engine.size] | join(", "))] | join(" ")), (["mean:", .mean] | join(" ")), (.runs |[ .[] | .timed | .duration_s], "-------------")'
fi
# echo $jq_pgm

rb_res=""
out_dir=$1
if [[ "$out_dir" == "" ]]; then
    last_dir=`ls $RAI_BENCH_DIR/output/ | tail -n 1`
    rb_res="$RAI_BENCH_DIR/output/$last_dir/*.jsonl"
else
    rb_res="$RAI_BENCH_DIR/output/$out_dir/*.jsonl"
fi

for json in $rb_res; do
    echo "===== summary results from: $json"
    # ignore first two lines with metrics for framework setup
    tail --lines=+3 $json | jq -r "$jq_pgm"
done
