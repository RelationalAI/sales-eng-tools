# Common tools for Sales Engineering
## Command-line tools and environment
Bash, Python, Julia, etc., tools for command line usage.

- **envcli_template.sh** <br/>
    Copy this template to create your own **envcli.sh** scripts,
    customized to each RAI project you work on.

    The bash scripts execute `source envcli.sh` to get your preferences for:

    - RAI_CLI_PROFILE - the `~/.rai/config` profile with your OAuth credentials (which match a specific RAI account)
    - RAI_CLI_ENGINE - your default Rel engine name in that RAI account
    - RAI_CLI_DATABASE - your default database in that RAI account
    - RAI_BENCH_DIR - your directory with the
    [Basic Workload Benchmarks](https://github.com/RelationalAI/basic-workloads-benchmarks)
    framework code

<br/>

- **bin/...** <br/>
    Bash scripts to simplify use of the CLI for RAI account management tasks.

    - **clone_database.sh** - create clone of an existing database in account RAI_CLI_PROFILE.
    Syntax follows Linux command conventions (cp, mv, etc):
    `clone_database.sh source-db clone-db`.
    - **create_engine.sh** - spin up new Rel engine.
    The default name is specified by RAI_CLI_ENGINE variable,
    but a different name can be specified on the command line.
    - **delete_engine.sh** - spin down an existing Rel engine.
    The default name is specified by RAI_CLI_ENGINE variable,
    but a different name can be specified on the command line.
    - **list_databases.sh** - list the databases in account RAI_CLI_PROFILE.
    - **list_edb_names.sh** - list the EDBs in database RAI_CLI_DATABASE, in account RAI_CLI_PROFILE.
    - **list_engines.sh** - list the active engines in account RAI_CLI_PROFILE.
    - **load_source.sh** - load specified Rel source file into RAI_CLI_DATABASE, using RAI_CLI_ENGINE, in account RAI_CLI_PROFILE.
    The relative path to the Rel source is preserved in the RAI model.
    - **rai_bench_results_summary.sh** - generate human-readable summary results from
    the JSON Lines (_*.jsonl_) files in a Basic Workloads Benchmark framework ("RAI bench") output directory.
    The location of the Basic Workloads directory is specified in RAI_BENCH_DIR.
    The most recent output directory is used by default,
    but a different name can be specified on the command line.

## Rel utilities
TBD...

## Spring REST API
TBD...
