#!/bin/bash
# Idea and original file by Joachim Neubert, 15.8.2012
# Updates and additional comments by Harald Weinreich, 29.10.2013
# Fixes for nonce by Jens Saak, 23.02.2024

# get CSV export files for abstract, speaker and session data from conftool

URL=$(cat .url) # Please enter your REST URL here.
PASSWORD=$(cat .secret) # use this if you have the password in a file called .secret
OUTPUTDIR="./CSV/"           # relative or absolute directory without trailing /
ABSTRACT_FILE="abstracts.csv"
SESSION_FILE="sessions.csv"
SPEAKER_FILE="speakers.csv"
CONTRIB_FILE="contributions.csv"

# set common parameters for REST access
common_param="page=adminExport"                        # mandatory to call export function
common_param+="&cmd_create_export=Create+Export+File"  # mandatory to execute export
common_param+="&form_include_deleted=0"                # include deleted / cancelled / withdrawn entries?
common_param+="&form_export_format=csv_semicolon"      # download format (xml, xml_short, csv_comma, xls...)
common_param+="&form_export_header=default"            # include header (for csv and excel export).


# parameters for abstract export
echo "Exporting abstracts..."

# create password hash salted with $TIMESTAMP used as nonce
# sha265sum returns a trailing "  -", so only get the first word
TIMESTAMP=$(date +%s%4N)
PASSHASH=$(echo -n "$TIMESTAMP$PASSWORD" | sha256sum | awk '{print $1;}')
ctdata="$common_param&nonce=$TIMESTAMP&passhash=$PASSHASH"
ctdata+="&export_select=papers"
ctdata+="&form_export_papers_options%5B%5D=abstracts"   # Additional parameter to include all abstracts.
ctdata+="&form_export_papers_options%5B%5D=authors_extended_email"
ctdata+="&form_export_papers_options%5B%5D=downloads"
#ctdata+="&form_track=3"  # Optional track selection
ctdata+="&form_status=p" # Optional status selection
curl --silent --request POST "$URL" --data "$ctdata" --output "$OUTPUTDIR"/"$ABSTRACT_FILE"

sleep 1 # required to make the nonce bigger than for the last call!


# parameters for contributions export
echo "Exporting contributions..."

# create password hash salted with $TIMESTAMP used as nonce
# sha265sum returns a trailing "  -", so only get the first word
TIMESTAMP=$(date +%s%4N)
PASSHASH=$(echo -n "$TIMESTAMP$PASSWORD" | sha256sum | awk '{print $1;}')
ctdata="$common_param&nonce=$TIMESTAMP&passhash=$PASSHASH"
ctdata+="&export_select=papers"
ctdata+="&form_export_papers_options%5B%5D=authors_extended"
ctdata+="&form_export_papers_options%5B%5D=authors_extended_presenters"
ctdata+="&form_export_papers_options%5B%5D=authors_extended_columns"
ctdata+="&form_export_papers_options%5B%5D=abstracts"                      # Additional parameter to include all abstracts.
ctdata+="&form_export_papers_options%5B%5D=session"
ctdata+="&form_export_papers_options%5B%5D=submitter"
ctdata+="&form_export_papers_options%5B%5D=newlines"
ctdata+="&form_status=p" # Optional status selection
curl --silent --request POST "$URL" --data "$ctdata" --output "$OUTPUTDIR"/"$CONTRIB_FILE"

sleep 1 # required to make the nonce bigger than for the last call!


# parameters for session export
echo "Exporting sessions..."

# nonce and passhash generation same as above
TIMESTAMP=$(date +%s%4N)
PASSHASH=$(echo -n "$TIMESTAMP$PASSWORD" | sha256sum | awk '{print $1;}')
ctdata="$common_param&nonce=$TIMESTAMP&passhash=$PASSHASH"
ctdata+="&export_select=sessions"
ctdata+="&form_export_sessions_options%5B%5D=presentations"
ctdata+="&form_export_sessions_options%5B%5D=presentations_abstracts"

curl --silent --request POST "$URL" --data "$ctdata" --output "$OUTPUTDIR"/"$SESSION_FILE"
sleep 1


# parameters for speaker export
echo "Exporting speakers..."

# nonce and passhash generation same as above
TIMESTAMP=$(date +%s%4N)
PASSHASH=$(echo -n "$TIMESTAMP$PASSWORD" | sha256sum | awk '{print $1;}')
ctdata="$common_param&nonce=$TIMESTAMP&passhash=$PASSHASH"
ctdata+="&export_select=subsumed_authors"
ctdata+="&form_status=p" # Status selection: Only authors of presented papers.

curl --silent --request POST "$URL" --data "$ctdata" --output "$OUTPUTDIR"/"$SPEAKER_FILE"

exit
