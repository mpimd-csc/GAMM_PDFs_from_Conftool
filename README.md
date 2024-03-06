# Book of Abstract and Daily Session Plan generator for the GAMM annual meeting from ConfTool

## Directory structure

+ `CSV` folder hosting the CSV files fetched from ConfTool using
  `get_conftool_data.py`.
+ `HTML`here we temporarily store the HTML versions of the abstracts.
+ `LaTeX`in here we build the actual PDF file for the book of abstract and
  daily session plans.
  + `Book_of_abstracts` the actual book of abstracts is built in here.
  + `Common`style files etc., used by both documents
  + `Contributions` the TeX files for the program items are put here to
    separate static content from auto-generated content.
  + `Daily_Session_Plans` the overview of all sessions in PDF format is
    generated here.
  + `Logos` this holds the GAMM logo for the title pages. Institutional logos
    could go here, too.

## REST API data fetcher

`get_conftool_data.py` is a script connecting to the ConfTool instance via ConfTool's REST API.
It relies on the hidden files

+ `.secret` (containing the Passphrase for the REST API from ConfTool's export settings for the event)
+ `.url` (containing the URL of the event in ConfTool)
  
residing in the same directory. The script stores the files

+ `abstracts.csv`
+ `contributions.csv`
+ `sessions.csv`
+ `speakers.csv`
+ `organizers.csv`

in the `CSV` directory. The actual generator only uses `sessions.csv` and `organizers.csv`, the others can be useful for consistency checks, as ConfTool adds hints where it suspects duplicates.

## Book of abstracts

## Daily Session plans
