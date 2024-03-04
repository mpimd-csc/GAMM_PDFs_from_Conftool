# Book of Abstract and Daily Session Plan generator for the GAMM annual meeting from ConfTool

## Directory structure

## REST API data fetcher

`get_conftool_data.sh` is a `BASH`-script connecting to the ConfTool instance via ConfTool's REST API.
It relies on hidden files

+ `.secret` (containing the Passphrase for the REST API from ConfTool's export settings for the event)
+ `.url` (containing the URL of the event in ConfTool)
  
residing in the same directory. The script stores the files

+ `abstracts.csv`
+ `contributions.csv`
+ `sessions.csv`
+ `speakers.csv`

in the `CSV` directory. The actual generator only uses `sessions.csv` and `organizers.csv`, the others can be useful for consistency checks, as ConfTool adds hints where it suspects duplicates.

## Book of abstracts

## Daily Session plans
