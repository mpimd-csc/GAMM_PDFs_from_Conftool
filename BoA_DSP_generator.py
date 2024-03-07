#!/usr/bin/env python3
import datetime as dt
import pandas as pd

from html2latex import html2latex 

def get_duration(start, end):
    start = start.replace(' ', 'T')
    end = end.replace(' ', 'T')
    dt1 = dt.datetime.fromisoformat(start)
    dt2 = dt.datetime.fromisoformat(end)
    return (dt2-dt1).total_seconds() / 60

def get_section_info(df, section):
    if section.startswith('DFG-PP'):
        section = section.replace('DFG-PP', 'SPP')
    if section.startswith('DFG-GRK'):
        section = section.replace('DFG-GRK', 'GRK')
    sect_organ = df[df['track_type'].str.startswith(section)]
    organizers = ''
    title = '\\color{red}{NOT AVAILABLE}'
    for index, row in sect_organ.iterrows():
        organizers += f'{row["name"]}, {row["firstname"]}{{\\em ({row["organisation"]})}}\\\\\n'
        title = f'{row["track_type"]}' 
    return title, organizers

def get_session_info(row):
    start = dt.datetime.fromisoformat(row['session_start'].replace(' ','T'))
    end   = dt.datetime.fromisoformat(row['session_end'].replace(' ','T'))
    c1 = row['chair1']
    c2 = row['chair2']
    c3 = row['chair3']

    if c3:
        chairs = f'{c1}\\\\\n{c2}\\\\\n{c3}'
    else:
        if c2:
            chairs = f'{c1}\\\\\n{c2}'
        else:
            chairs = c1

    session = {
        "chairs"   : chairs,
        "number"   : row['session_short'],
        "name"     : row['session_title'],
        "room"     : row['session_room'],
        "start"    : start.strftime("%H:%M"),
        "end"      : end.strftime("%H:%M"),
        "date"     : start.strftime("%B %d, %Y")
    }
    return session

def get_contribution_info(row, idx):
    ptitle     = f'p{idx}_title'
    pauthors   = f'p{idx}_authors'
    porgas     = f'p{idx}_organisations'
    ppresenter = f'p{idx}_presenting_author'
    pabstract  = f'p{idx}_abstract'
    pstart     = f'p{idx}_start'
    pend       = f'p{idx}_end'

    presenter = row[ppresenter]
    if pd.isna(presenter):
        return None
    authors = row[pauthors]
    authors = authors.replace(presenter, f'\\underline{{{presenter}}}')
    contribution = {
        "title"    : row[ptitle],
        "authors"  : authors,
        "start"    : row[pstart],
        "end"      : row[pend],
        "duration" : get_duration(row[pstart], row[pend]),
        "abstract" : html2latex(row[pabstract]),
        "organizations" : row[porgas]
    }
    return contribution

def get_plenary_info(row):
    start = dt.datetime.fromisoformat(row['session_start'].replace(' ','T'))
    end   = dt.datetime.fromisoformat(row['session_end'].replace(' ','T'))
    if pd.isna(row['chair1']):
        chair = '\color{red} NOT AVAILABLE'
    else:
        chair = row['chair1']
    contribution = {
        "session"  : row['session_short'],
        "title"    : row['p1_title'],
        "speaker"  : row['p1_presenting_author'],
        "chair"    : chair,
        "room"     : row['session_room'],
        "start"    : start.strftime("%H:%M"),
        "end"      : end.strftime("%H:%M"),
        "date"     : start.strftime("%B %d, %Y")
    }
    return contribution

def write_PML(df, outdir):
    file = open(outdir+'/PML.tex', 'w', encoding='utf-8')
    for index, row in df.iterrows():
        PML = get_plenary_info(row)
        ostring  = f'\\Prandtl{{{PML["title"]}}}%\n'
        ostring += f'        {{{PML["date"]}}}%\n'
        ostring += f'        {{{PML["start"]}}}%\n'
        ostring += f'        {{{PML["end"]}}}%\n'
        ostring += f'        {{{PML["room"]}}}%\n'
        ostring += f'        {{{PML["chair"]}}}'
        file.write(ostring)
        file.close()
    return '\\input{PML.tex}\n'

def write_PL(df, outdir):
    inputs = ''
    for index, row in df.iterrows():        
        PL = get_plenary_info(row)
        fname = f'{PL["session"]}.tex'
        file = open(outdir+'/'+fname, 'w', encoding='utf-8')
        ostring  = f'\\Plenary{{{PL["title"]}}}%\n'
        ostring += f'        {{{PL["date"]}}}%\n'
        ostring += f'        {{{PL["start"]}}}%\n'
        ostring += f'        {{{PL["end"]}}}%\n'
        ostring += f'        {{{PL["room"]}}}%\n'
        ostring += f'        {{{PL["chair"]}}}'
        file.write(ostring)
        file.close()
        inputs += f'\\input{{{fname}}}\n'
    return inputs

def write_section(org, sec, df, outdir):
    fname = sec.replace(' ', '_')
    fullname = outdir+'/'+fname+'.tex'
    file = open(fullname, 'w', encoding='utf-8')
    title, organizers  = get_section_info(org, sec)
    ostring  = f'\\Section{{{title}}}%\n'
    ostring += f'        {{{organizers}}}\n\n'

    sessions = df[df['session_short'].str.startswith(sec)]
    for index, row in sessions.iterrows():
        S = get_session_info(row)
        ostring += f'\\Session{{{S["number"]}}}%\n'
        ostring += f'{{{S["name"]}}}%\n'
        ostring += f'{{{S["date"]}}}%\n'
        ostring += f'{{{S["start"]}}}%\n'
        ostring += f'{{{S["end"]}}}%\n'
        ostring += f'{{{S["room"]}}}%\n'
        ostring += f'{{{S["chairs"]}}}%\n'
        for i in range(1,7):
            C = get_contribution_info(row, i)
            if C is None:
                break
            ostring += f'\\Contribution{{{C["title"]}}}%\n'
            ostring += f'{{{C["authors"]}}}%\n'
            ostring += f'{{{C["start"]}}}%\n'
            ostring += f'{{{C["organizations"]}}}'
            ostring += f'{{{html2latex(C["abstract"])}}}%\n'
    file.write(ostring)
    file.close()
    return fname

def write_sections(organizers, sessions, outdir):
    inputs = ''
    for i in range(1,27):
        if not i == 6:
            fname = write_section(organizers, f'S{i:02}', sessions, outdir)
            inputs += f'\\input{{{fname}}}\n'
        else:
            fname1 = write_section(organizers, f'S{i:02}.1', sessions, outdir)
            fname2 = write_section(organizers, f'S{i:02}.2', sessions, outdir)
            inputs += f'\\input{{{fname1}}}\n\\input{{{fname2}}}\n'
    return inputs

def write_minis(organizers, MS, YRM, outdir):
    inputs = ''
    for i in range(1,len(MS)+1):
        name = f'MS{i}'
        fname = write_section(organizers, name, MS, outdir)
        inputs += f'\\input{{{fname}}}\n'

    for i in range(len(YRM)):
        name = f'YRM{i}'
        fname = write_section(organizers, name, YRM, outdir)
        inputs += f'\\input{{{fname}}}\n'
    return inputs

def write_dfg(organizers, df, outdir):
    inputs = ''
    for index, row in df.iterrows():
        fname = write_section(organizers, row['session_short'], df, outdir)
        inputs += f'\\input{{{fname}}}\n'
    return inputs


def make_boa():
    # Read the Sessions exported from ConfTool
    df = pd.read_csv('CSV/sessions.csv', sep=';', quotechar='"')
    
    # get rid of empty columns
    # TODO: preselect the relevant columns to read (see Organizers below)
    df.dropna(axis='columns', how='all', inplace=True)


    # Filter by the categories desired as chapter in the BoA
    DFG              = df[df['session_short'].str.startswith('DFG')].sort_values(by='session_short')
    Prandtl          = df[df['session_short'].str.startswith('PML')].sort_values(by='session_short')
    Plenaries        = df[df['session_short'].str.startswith('PL')].sort_values(by='session_short')
    Minisymposia     = df[df['session_short'].str.startswith('MS')].sort_values(by='session_short')
    YoungResearchers = df[df['session_short'].str.startswith('YRM')].sort_values(by='session_short')
    Contributed      = df[df['session_short'].str.startswith('S')].sort_values(by='session_short')

    # Read the relevant Organizer information exported from ConfTool
    Organizers = pd.read_csv('CSV/organizers.csv', 
                            sep=';', 
                            quotechar='"', 
                            usecols=['track_type', 'name', 'firstname', 'organisation'])
    # drop everyone whos not a session organizer and sort by sections
    Organizers = Organizers[Organizers.track_type.notnull()].sort_values(by='track_type')

    outdir  = './LaTeX/Contributions/'
    inputs  = '{\\color{primary}\chapter{Prandtl Memorial Lexture and Plenary Lecture}}'
    inputs += write_PML(Prandtl, outdir)
    inputs += write_PL(Plenaries, outdir)
    inputs += '{\\color{primary}\chapter{Minisymposia and Young Researchers Minisymposia}}'
    inputs += write_minis(Organizers, Minisymposia, YoungResearchers, outdir)
    inputs += '{\\color{primary}\chapter{DFG Programs}}'
    inputs += write_dfg(Organizers, DFG, outdir)
    inputs += '{\\color{primary}\chapter{Cotributed Sessions}}'
    inputs += write_sections(Organizers, Contributed, outdir)

    boa = open('./LaTeX/Book_of_abstracts/BookOfAbstracts.tex', 'w', encoding = 'utf-8')
    contents = '''
 \\documentclass[colorlinks]{gamm-boa}

 \\begin{document}
 \\tableofcontents

CONTENTS

\\end{document}
    '''
    contents = contents.replace('CONTENTS', inputs)
    boa.write(contents)
    boa.close()

def main():
    make_boa()

if __name__ == "__main__":
    main()
