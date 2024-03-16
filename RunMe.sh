#!/bin/bash

make_boa () {
    cd LaTeX/Book_of_abstracts || exit 3
    latexmk -pdf BookOfAbstracts.tex || exit 4
	cp ./BookOfAbstracts.pdf "$CWD"
    cd "$CWD" || exit 255
}

make_dsp () {
    cd LaTeX/Daily_Scientific_Program || exit 5
    latexmk -pdf Daily_Scientific_Program.tex || exit 6
	cp ./Daily_Scientific_Program.pdf "$CWD"
    cd "$CWD" || exit 255
}

make_room_plans () {
    cd LaTeX/Daily_Scientific_Program/rooms || exit 7
    find . -maxdepth 1 -name "*.tex" -exec latexmk -pdf {} \;
	cp ./*.pdf "$CWD"
    cd "$CWD" || exit 255
}

USAGE="Usage: RunMe.sh [option]

Options:
 -h,-?    print this help text
 -b       generate book of abstracts
 -d,-s    generate daily scientific program
 -r       generate room plans
 -a       generate all PDFs

"

CWD=$(pwd)

# Fetch data from ConfTool Pro
./get_conftool_data.py || exit 1
# create LaTeX files
./BoA_DSP_generator.py || exit 2

# Default action if no option is provided
action="all"

# Parse command-line options
while getopts "bdsrah?" opt; do
  case ${opt} in
    b )
      action="boa"
      ;;
    d )
      action="dsp"
      ;;
    s )
      action="dsp"
      ;;
    r )
      action="rooms"
      ;;
    a )
      action="all"
      ;;
    h )
      echo "$USAGE" && exit 0
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
  esac
done

# Execute functions based on the selected action
case $action in
  boa)
    make_boa
    ;;
  dsp)
    make_dsp
    ;;
  rooms)
    make_room_plans
    ;;
  all)
    make_boa
    make_dsp
    make_room_plans
    ;;
esac
