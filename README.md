# Common tools from Sales Engineering

This is a public repo to contain libraries, utilities, and other resources created by Sales Engineering and others to 
support and enhance ongoing and future RAI projects. 
These resources are not client-specific, can be freely shared, distributed and updated in the spirit of OSS. 

Free License is pending.

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
    - **create_project_skel.sh** - create the directory structure for a new customer project
    - **delete_engine.sh** - spin down an existing Rel engine.
    The default name is specified by RAI_CLI_ENGINE variable,
    but a different name can be specified on the command line.
    - **list_databases.sh** - list the databases in account RAI_CLI_PROFILE.
    - **list_edb_names.sh** - list the EDBs in database RAI_CLI_DATABASE, in account RAI_CLI_PROFILE.
    - **list_engines.sh** - list the active engines in account RAI_CLI_PROFILE.
    - **load_source.sh** - load specified Rel source file into RAI_CLI_DATABASE, using RAI_CLI_ENGINE, in account RAI_CLI_PROFILE.
    The relative path to the Rel source is preserved in the RAI model unless old/new reparenting directories are specified. 
    - **rai_bench_results_summary.sh** - generate human-readable summary results from
    the JSON Lines (_*.jsonl_) files in a Basic Workloads Benchmark framework ("RAI bench") output directory.
    The location of the Basic Workloads directory is specified in RAI_BENCH_DIR.
    The most recent output directory is used by default,
    but a different name can be specified on the command line.

## SE Rel library

Folder [se_lib](/se_lib) contains Rel models:

  * [util.rel](/se_lib/util.rel): collection of useful general purpose functions supplementing standard library functions
  * [visual.rel](/se_lib/visual.rel): graphviz-based visualization functions for knowledge graphs, ontology, etc.
  * [debug.rel](/se_lib/debug.rel): TBD

### Options (Configuration) Module Format

Example of options module (`OPTS`) passed to knowledge graph functions:
```
module kg_options
  module graphviz
    def title = "Knowledge Graph" // Graph Title
    def layout = "dot"
    def direction = "TD"
    def entity_shape = {(:Customer, "oval");
                        (:Bank, "box");}
    def label_edges = boolean_false
  end
end
```

Knowldge graph visualization functions take 
## Spring REST API
TBD...

### Main and Big Ideas

#### Resarch Upstream that results in Product Downstream - no exceptions and identified and planed from the beginning:

  * Teams like DS team should be "research"-focused upstrem and "product"-bound downstream. It means that they start with and do research/dev that should always result in identified and defined products or product enhancements.









Back to Shesterkin. He apparently "starred" in the exhibition game where #WarCrimes Putin scored 8 goals against him (the game took place in May 2019 before full scale #UkraineRussiaWar):
https://twitter.com/eddie_p_412/status/1523851402103111680?s=20&t=c6OjwKxXmgbTw9SRU3eH1w
3/4
