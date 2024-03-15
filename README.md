# Book of Abstract and Daily Session Plan generator for the GAMM annual meeting from ConfTool

## Directory structure

+ `CSV` folder hosting the CSV files fetched from ConfTool using
  `get_conftool_data.py`.
+ `HTML`here we temporarily store the HTML versions of the abstracts.
+ `LaTeX`in here we build the actual PDF file for the book of abstract and
  daily session plans.
   + `Book_of_abstracts` the actual book of abstracts is built in here.
      + `Contributions` the TeX files for the program items are put
        here to separate static content from auto-generated content.
         + `Logos` this holds the GAMM logo for the title
           pages. Institutional logos could go here, too.
   + `Common`style files etc., used by both documents
   + `Daily_Scientific_Program` the overview of all sessions in PDF format
     is generated here.

## REST API data fetcher

### `get_conftool_data.py`

This is a script connecting to the ConfTool Pro instance
via ConfTool's REST API.  It relies on the hidden files

+ `.secret`
  (containing the Passphrase for the REST API from
   ConfTool's export settings for the event)
+ `.url`
  (containing the URL of the event in ConfTool)

residing in the same directory. The script stores the files

+ `abstracts.csv`
+ `contributions.csv`
+ `sessions.csv`
+ `speakers.csv`
+ `organizers.csv`

in the `CSV` directory. The actual generator only uses `sessions.csv`
and `organizers.csv`, the others can be useful for consistency checks,
as ConfTool adds hints where it suspects duplicates.

To fill `.url` and `.secret`, first you need to enable the REST
interface of ConfTool Pro. Otherwise access is disabled. To enable
the interface go to:

Overview => Data Import and Export => Integrations With Other Systems

Scroll down to "Enable General REST Interface" to define a shared
passphrase and enable the interface. The passphrase must have at least
8 characters. This passphrase then goes into `.secret` as its only content.

Below the field you can also find the URL of the REST interface. It
looks like the following:
[https://www.conftool.net/my_conference/rest.php](https://www.conftool.net/my_conference/rest.php).
Copy this URL into the `.url` file.

### `BoA_DSP_generator.py`

This is the actual generator script that can be run once the CSV files
have been fetched. It does three things:

+ prepare the `BookOfAbstracts.tex` in the `Book_of_abstracts` folder,
  and its includes for all sessions in the `Contributions` subfolder.
+ prepare the `Daily_Scientific_Program.tex` in the
  `Daily_Scientific_Program` folder.
+ For each room listed in the schedule, produce a separate TeX file
  with the room schedule of the week in the
  `Daily_Scientific_Program/rooms` folder.

### `html2latex.py`

This a simple module containing the single function `html2latex` for cleaning
out a selection of HTML tags. It can be extended by additional tags as
required. There are also a PyPI and some GitHub projects by the same
name that we decided to avoid here as they have been unattended or
even archived.

### `check_html_tags.py`

The script `check_html_tags.py` is not necessary for the generation of
the above TeX files, but it checks if all HTML tags used in the CSV
files are covered by `html2latex.py`.

## Book of abstracts

The actual book of abstracts is prepared in the aforementioned
subfolder. To customize colors and logos for the current years GAMM,
simply update the file `this-gamm.sty` Setting the appropriate colors,
date information and logos. Also replace the cover-image by your image
of choice. Note that the image can have any file format supported by
the `graphicx` package, but will be forced (without keeping the aspect
ratio) into a 4:3 frame on the title page.

## Daily Session plans

The daily session plan relies on a couple of choices regarding the
implementation and naming of of the schedule items in the ConFTool
setup of the conference. If you base your setup (e.g. by asking
ConfTool for a data import) on the Setup of the
2024  edition of GAMM in Magdeburg, you should get this setup
automatically. These settings are:

+ the short titles of all plenary sessions start with PL
+ the short titles of the Prandtl memorial lecture is PML
+ the short title(s) of the von Mises price lecture(s) start with RvML
+ the short titles of all minisymposium  sessions start with MS
+ the short titles of all young researchers minis start with YRM
+ the short titles of all sessions for DFG programs start with DFG
+ the short titles of all parallel sessions start with S
+ the poster session(s) start with Poster

all sessions are either 1h or 2h long and non-plenary contributions
are by default 20 minutes long. Topical speakers can have double
slots, i.e. 40 minutes. In Minisymposia, 30 minutes presentations are
allowed, but only if all talks in the session are 30 minutes long.
Any other setting may (and likely will) break the logic of the
 generator.

## Getting Started

Before starting the process, make sure to review the user data in the
ConfTool. You will likely have to post-process a large number of
submissions. Common mistakes are:

+ abstracts copy&pasted from PDF files, inheriting all line breaks and
  hyphenation
+ weird indentation, and wrong global formatting (entire abstracts in
  bold face or superscript)
+ inconsistencies and typos in affiliations

This is tedious and time-consuming, so best start early with this.

For the actual processing , make sure you have at least Python 3.10,
with the `pandas`, `requests` and `datetime` modules installed. We
recommend to use a virtual environment for that. Also make sure to
have a recent LaTeX installation (ideally also providing `latexmk`).

1. Go to the main folder, where you also find this README.md create
   `.url` and `.secret` in this folder according to the instructions
   above, and execute `get_conftool_data.py`. Depending on your
   network connection, as well as the number of submissions and
   participants, this may take a short while.

2. Once that has finished you can switch to the `LaTeX` folder. Update
  `this-gam.sty` according to your needs, here.

3. Now go to the `Book_of_abstracts` folder and try running `pdflatex`
  on the `BookOfAbstracts.tex`. This has some probability to fail, as
  ConfTool  allows  full UTF-8 input in the abstract submission and
  not all incompatible letters or hidden whitespace letters may be
  covered in the `janitor` function translating them to appropriate
  LaTeX transcriptions. Extend the function in the
  `BoA_DSP_generator.py` file as needed and rerun that in the top-level
  directory. Once it succeeds run `makeindex`to generate the
  alphabetical authors index, followed by `pdflatex` again to include
  it. Alternatively, directly run `latexmk` on the
  `BookOfAbstracts.tex` to automate the procedure.

4. Now go to `Daily_Scientific_Program` and repeat the above for
   `Daily_Scientific_Program.tex`.

5. Finally, change to the `rooms` folder and also compile all TeX
   files there.
