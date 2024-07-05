#!/usr/bin/env python3
# This file is part of the GAMM_PDFs_FROM_CONFTOOL project.
# Copyright GAMM_PDFs_FROM_CONFTOOL developers and contributors. All rights reserved.
# License: BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)

import pandas as pd
import re
from html2latex import html2latex 

def print_tags(instr):
    # Regular expression to match HTML tags
    tag_regex = re.compile('<[a-zA-Z/]{1}[^><]+>')

    # Use a set to collect unique tags
    unique_tags = set()

    tags = tag_regex.findall(instr)
    for tag in tags:
        unique_tags.add(tag)

    # Print each unique tag
    for tag in unique_tags:
        print(tag)

# Step 1: Quickly scan the CSV for column names
with open('./CSV/sessions.csv', 'r', encoding='utf-8') as file:
    first_line = file.readline()
    all_columns = first_line.strip().split(';')

# Filter column names containing 'abstract'
abstract_columns = [col.replace('"', '') for col in all_columns if 'abstract' in col]

# Step 2: Read the CSV with selected columns
df = pd.read_csv('./CSV/sessions.csv',  sep=';', quotechar='"', usecols=abstract_columns)

# Now df contains only the columns whose names contain 'abstract'
# You can proceed to concatenate their contents and write to a file as needed

# Step 3: Concatenate all row contents from the 'abstract' columns
# Adjust the separator if needed, here it's assumed to be a space
all_abstracts = df.apply(lambda x: ' '.join(x.dropna().astype(str)), axis=1).str.cat(sep='\n\n')

# Step 4: Write the concatenated string to a UTF-8 encoded file
with open('all_abstracts.html', 'w', encoding='utf-8') as file:
    file.write(all_abstracts)


# Step 5: find all html tags in all_abstracts and write them to the screen
print_tags(all_abstracts)

# Step 6: replace all html tags by LaTeX equivalents
all_abstracts = html2latex(all_abstracts)
print('\nRemaining tags\n')
print_tags(all_abstracts)

# Step 7: Write the LaTeX string to a UTF-8 encoded file
with open('all_abstracts.tex', 'w', encoding='utf-8') as file:
    file.write(all_abstracts)