import datetime as dt
import pandas as pd

def get_duration(start, end):
    start = start.replace(' ', 'T')
    end = end.replace(' ', 'T')
    dt1 = dt.datetime.fromisoformat(start)
    dt2 = dt.datetime.fromisoformat(end)
    return (dt2-dt1).minute()

def get_section_info(df, section):
    sect_organ = df[df['track_type'].str.startswith(section)]
    organizers = ''
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
        "date"     : start.strftime("%d.%B.%y")
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
    authors = row[pauthors].replace(presenter, f'\\underline{{{presenter}}}')
    contribution = {
        "title"    : row[ptitle],
        "authors"  : authors,
        "start"    : row[pstart],
        "end"      : row[pend],
        "duration" : get_duration(row[pstart], row[pend]),
        "abstract" : row[pabstract],
        "organizations" : row[porgas]
    }
    return contribution

def get_plenary_info(row):
    start = dt.datetime.fromisoformat(row['session_start'].replace(' ','T'))
    end   = dt.datetime.fromisoformat(row['session_end'].replace(' ','T'))
    contribution = {
        "session"  : row['session_short'],
        "title"    : row['p1_title'],
        "speaker"  : row['p1_presenting_speaker'],
        "chair"    : row['chair1'],
        "room"     : row['session_room'],
        "start"    : start.strftime("%H:%M"),
        "end"      : end.strftime("%H:%M"),
        "date"     : start.strftime("%d.%B.%y")
    }
    return contribution

def write_PML(df, outdir):
    file = open(outdir+'/PML.tex', 'w', encoding='utf-8')
    for index, row in df.iterrows():
        PML = get_plenary_info(row)
        ostring  = f'\\Prandtl{{{PML['title']}}}%\n'
        ostring += f'        {{{PML['date']}}}%\n'
        ostring += f'        {{{PML['start']}}}%\n'
        ostring += f'        {{{PML['end']}}}%\n'
        ostring += f'        {{{PML['room']}}}%\n'
        ostring += f'        {{{PML['chair']}}}'
        file.write(ostring)
        file.close()
    return '\\input{PML.tex}\n'

def write_PL(df, outdir):
    inputs = ''
    for index, row in df.iterrows():        
        PL = get_plenary_info(row)
        fname = f'{PL['session']}.tex'
        file = open(outdir+'/'+fname, 'w', encoding='utf-8')
        ostring  = f'\\Prandtl{{{PL['title']}}}%\n'
        ostring += f'        {{{PL['date']}}}%\n'
        ostring += f'        {{{PL['start']}}}%\n'
        ostring += f'        {{{PL['end']}}}%\n'
        ostring += f'        {{{PL['room']}}}%\n'
        ostring += f'        {{{PL['chair']}}}'
        file.write(ostring)
        file.close()
        inputs += f'\\input{{{fname}}}\n'
    return inputs

def write_section(org, sec, df, outdir):
    fname = outdir+'/'+f'{sec.replace(' ', '_')}.tex'
    file = open(fname, 'w', encoding='utf-8')
    SEC = get_section_info(org, sec)
    ostring  = f'\\Section{{{SEC['title']}}}%\n'
    ostring += f'        {{{SEC['organizers']}}}\n\n'

    sessions = df[df['session_short'].str.startswith(sec)]
    for index, row in sessions.iterrows():
        S = get_session_info(row)
        ostring += f'\\Session{{{S['number']}}}%\n'
        ostring += f'{{{S['name']}}}%\n'
        ostring += f'{{{S['date']}}}%\n'
        ostring += f'{{{S['start']}}}%\n'
        ostring += f'{{{S['end']}}}%\n'
        ostring += f'{{{S['room']}}}%\n'
        ostring += f'{{{S['chairs']}}}%\n'
        for i in range(1,7):
            C = get_contribution_info(row, i)
            ostring += f'\\Contribution{{{C['title']}}}%\n'
            ostring += f'{{{C['authors']}}}%\n'
            ostring += f'{{{C['start']}}}%\n'
            ostring += f'{{{C['organizations']}}}'
            ostring += f'{{{C['abstract']}}}%\n'
    file.write(ostring)
    file.close()

def write_sections(organizers, sessions, outdir):
    for i in range(26):
        inputs = ''
        if not i == 6:
            write_section(organizers, f'S{i:2}', sessions, outdir)
            inputs += f'S{i:2}.tex\n'
        else:
            write_section(organizers, f'S{i:2}.1', sessions, outdir)
            write_section(organizers, f'S{i:2}.2', sessions, outdir)
            inputs += f'S{i:2}.1.tex\nS{i:2}.2.tex\n'
    return inputs

def write_minis(organizers, MS, YRM, outdir):
    inputs = ''
    for i in range(len(MS)):
        name = f'MS{i}'
        write_section(organizers, name, MS, outdir)
        inputs += f'\\input{{{name}.tex}}\n'

    for i in range(len(YRM)):
        name = f'YRM{i}'
        write_section(organizers, name, YRM, outdir)
        inputs += f'\\input{{{name}.tex}}\n'
    return inputs

def write_dfg(organizers, df, outdir):
    inputs = ''
    for index, row in df.iterrows():
        write_section(organizers, row['session_short'], outdir)
        inputs += f'\\input{{{row['session_short'].replace(' ', '_')}}}'
    return inputs


def main():
    # Read the Sessions exported from ConfTool
    df = pd.read_csv('CSV/sessions.csv', sep=';', quotechar='"')
    
    # get rid of empty columns
    # TODO: preselect the relevant columns to read (see Organizers below)
    df.dropna(axis='columns', how='all', inplace=True)


    # Filter by the categories desired as chapter in the BoA
    DFG              = df[df['session_short'].str.startswith('DFG')].sort_values(by='session_short')
    Prandtl          = df[df['session_short'].str.startswith('PML')].sort_values(by='session_short')
    Plenaries        = df[df['session_short'].str.startswith('PL')].sort_values(by='session_short')
    Minisymposia     = df[df['session_short'].str.startswith('MR')].sort_values(by='session_short')
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
    inputs  = ''
    inputs += write_PML(Prandtl, outdir)
    inputs += write_PL(Plenaries, outdir)
    inputs += write_minis(Organizers, Minisymposia, YoungResearchers, outdir)
    inputs += write_dfg(Organizers, DFG, outdir)
    inputs += write_sections(Organizers, Contributed, outdir)

    boa = open('./LaTeX/Book_of_abstracts/BookOfAbstracts.tex', 'w', encoding = 'utf-8')
    contents = '''
    \\documentclass[colorlinks]{gamm-boa}

    \\begin{document}
    \\tableofcontents

    CONTENTS

    \\end{document}
    '''
    contents.replace('CONTENS', inputs)
    boa.write(contents)
    boa.close()

 
if __name__ == "__main__":
    main()
