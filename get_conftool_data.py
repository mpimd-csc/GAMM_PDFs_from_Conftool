#!/usr/bin/env python3
# This file is part of the GAMM_PDFs_FROM_CONFTOOL project.
# Copyright GAMM_PDFs_FROM_CONFTOOL developers and contributors. All rights reserved.
# License: BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)

import hashlib
import time
import requests
import os

# configuration
url = open('.url').read().strip()          # read URL from .url
password = open('.secret').read().strip()  # read password from .secret
output_dir = "./CSV"                       # where to put the CSVs

# output file names for the different categories
files = {
    "abstracts":     "abstracts.csv",
    "sessions":      "sessions.csv",
    "speakers":      "speakers.csv",
    "contributions": "contributions.csv",
    "organizers":    "organizers.csv"
}

# common request parameters for the REST API needed for all queries
common_param = {
    "page": "adminExport",                      # mandatory
    "cmd_create_export": "Create+Export+File",  # mandatory
    "form_include_deleted": "0",                # cleaned output
    "form_export_format": "csv_semicolon",      # other options csv_comma, xml, xml_short, xls
    "form_export_header": "default"             # we need the headers to locate the required columns
}

# specific request parameters per output type
exports = {
    "abstracts": {
        "export_select": "papers",
        "form_export_papers_options[]": ["abstracts",
                                         "authors_extended_email",
                                         "downloads"],
        "form_status": "p"
    },
    "contributions": {
        "export_select": "papers",
        "form_export_papers_options[]": ["authors_extended",
                                         "authors_extended_presenters",
                                         "authors_extended_columns",
                                         "abstracts",
                                         "session",
                                         "submitter",
                                         "newlines"],
        "form_status": "p"
    },
    "sessions": {
        "export_select": "sessions",
        "form_export_sessions_options[]": ["presentations",
                                           "presentations_abstracts"]
    },
    "speakers": {
        "export_select": "subsumed_authors",
        "form_status": "p"
    },
    "organizers": {
        "export_select": "reviewers",
        "form_status": "p"
    }
}

# helper function generating a unique timestamp and password hash combination
# for the REST auuthentication
def generate_nonce_and_passhash():
 
    timestamp = str(int(time.time() * 10000))
    passhash = hashlib.sha256((timestamp + password).encode()).hexdigest()
 
    return timestamp, passhash

# here is the function tha does the actual requests and saves the corresponding
# files note the sleep at the end to ensure unique timestamps and hashes
def export_data(export_name, export_params):
 
    print(f"Exporting {export_name}...")
 
    timestamp, passhash = generate_nonce_and_passhash()
 
    data = {**common_param, **export_params,
            "nonce": timestamp, "passhash": passhash}
 
    response = requests.post(url, data=data)
 
    with open(os.path.join(output_dir, files[export_name]), 'wb') as f:
        f.write(response.content)
    time.sleep(1)

# unless output_dir points to something else than ./CSV this should actually
# not be necessary
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# and finally the loop over all configured exports
for export_name, export_params in exports.items():
    export_data(export_name, export_params)
