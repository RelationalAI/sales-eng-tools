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

    Python tools for testing.

    - **parse_csv.py** - use Python's `csv` reader to explore customer-provided CSV files
    (if RAI's `load_csv` doesn't behave as expected).
    Use `parse_csv.py --file foo.csv --top 5 --full` to get started.
    Use `parse_csv.py --help` for full help.

## SE Rel library

Folder [se_lib](/se_lib) contains Rel models for with various sets of utilities:

  * [csv.rel](/se_lib/csv.rel): CSV file parsing and loading
  * [query.rel](/se_lib/query.rel): Tools for querying and poking around RAI database relations
  * [kg.rel](/se_lib/kg.rel): functions to construct, manipulate, operate on and visualize knowledge graphs based on standard data model
  * [graph.rel](/se_lib/graph.rel): functions to operate on Rel graph objects
  * [util.rel](/se_lib/util.rel): collection of useful general purpose functions supplementing standard library functions
  * [viz.rel](/se_lib/viz.rel): helper functions for graphviz, vega/vega-lite, and other visualization libraries
  * [visual.rel](/se_lib/visual.rel) (**DEPRECATED**: do not use or stop using): graphviz-based visualization functions for knowledge graphs, ontology, etc.


  * [debug.rel](/se_lib/debug.rel): TBD

### util.rel


### kg.rel

#### Options (Configuration) Module Format

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

Knowldge graph visualization functions take ...

### csv.rel

To parse and map a CSV file into standard model use utility function `parse_attributes` defined in `csv.rel`.

Below is example from IMDB demo (see [imdb_model](https://github.com/RelationalAI/sales-engineering/blob/main/demos/imdb/notebooks/imdb_model.json) notebook for full code).

#### Importing CSV file into RAI

Suppose we have CSV file containing IMDB titles that has been loaded from Azure store like this:
```
// Title CSV
@no_diagnostics(:UNDEFINED_IDENTIFIER)
def delete[:title_csv] = title_csv
def title_config:path = "s3://psilabs-public-files/imdb/title_basics_1953_votes_30.csv"
def insert[:title_csv] = lined_csv[load_csv[title_config]]
```

#### Defining Entity Type

The data will be used to create and populate entity `Title`. For this purpose we define several auxilary modules. First, module `create_entity` defines entity `Title` and its constructor function `title_from_id`:
```
entity type Title = String
entity type Name = String

module create_entity
    def Title[x] = ^Title[x]
    def title_from_id(id, e) = create_entity:Title[id](e) and
                                title_csv(imdb_meta:title:key, _, id)

    def Name[x] = ^Name[x]
    def name_from_id(id, e) = create_entity:Name[id](e) and
                                title_csv(imdb_meta:name:key, _, id)
end
```

#### Declaring Metadata

Note, that we already used element from another auxilary module `imdb_meta` that defines all necessary metadata to load, parse, and define `Title` entity from CSV:
```
module imdb_meta

    module title
        def entity_name = :Title
        def key = :tconst
        def as_is_attr = {
            :primaryTitle;
            :titleType;
        }
        def int_attr = {
            :startYear; :endYear; :numVotes; :runtimeMinutes;
        }
        def float_attr = {
            :averageRating
        }
        def attr_alias_map = {
            (:tconst, :id);
        }
    end

    module name
        def entity_name = :Name
        def key = :nconst
        def as_is_attr = {
            :primaryName;
            :primaryProfession;
        }
        def int_attr = {
            :birthYear; :deathYear;
        }
        def attr_alias_map = {
            (:nconst, :id);
        }
    end

end
```

There are more elements meta module may define depending on CSV file content, for example, it could also define `datetime_attr` and `date_attr`.

Let's review what meta module does.

First, we **always** define `entity_name` (usually by capitalizing first letter) and `key` (only single value keys are supported currently) like this:
```
def enity_name = :Title
def key = :tconst
```
Next, we define fields according to their types. If the field type doesn't change from the one parsed/recognized by `load_csv` then it belongs to `as_is_attr`:
```
def as_is_attr = {
            :primaryTitle;
            :titleType;
}
```

For integer fields loaded as strings use `int_attr`:
```
def int_attr = {
            :startYear; :endYear; :numVotes; :runtimeMinutes;
}

```

For float (decimals) use `float_attr`:
```
def float_attr = {
            :averageRating
}
```

For parsing `date` and `datetime` us date_attr and datetime_attr correspondingly (example not applicable to IMDB):
```
def datetime_attr = {
            (:CreationDate, "y-m-dTH:M:S.sss");
            (:LastAccessDate, "y-m-dTH:M:S.sss");
}
```

More types could be supported in the future.

Finally, use `attr_alias_map` to rename attributes (if necessary):
```
def attr_alias_map = {
            (:nconst, :id);
        }
```

Finally, we can create data model by mapping CSV file:
```
with se_csv use parse_attributes

module imdb_data

    // Title entity data
    def title:id = transpose[create_entity:title_from_id]
    def title(attr, e, val) = parse_attributes[title:id, title_csv, imdb_meta:title](attr, e, val)

end
```


## Spring REST API
TBD...

### Main and Big Ideas

#### Resarch Upstream that results in Product Downstream - no exceptions and identified and planed from the beginning:

  * Teams like DS team should be "research"-focused upstrem and "product"-bound downstream. It means that they start with and do research/dev that should always result in identified and defined products or product enhancements.









Back to Shesterkin. He apparently "starred" in the exhibition game where #WarCrimes Putin scored 8 goals against him (the game took place in May 2019 before full scale #UkraineRussiaWar):
https://twitter.com/eddie_p_412/status/1523851402103111680?s=20&t=c6OjwKxXmgbTw9SRU3eH1w
3/4
