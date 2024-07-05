#!/usr/bin/env python3
# This file is part of the GAMM_PDFs_FROM_CONFTOOL project.
# Copyright GAMM_PDFs_FROM_CONFTOOL developers and contributors. All rights reserved.
# License: BSD 2-Clause License (https://opensource.org/licenses/BSD-2-Clause)

import re
def html2latex(instr):
    instr = instr.replace('<br />', '\\newline ')
    instr = re.sub('<p[^><]*>', '', instr).replace('</p>', '\\par')
    instr = instr.replace('<li>', '\\item ').replace('</li>', '')
    instr = instr.replace('<ol>', '\\begin{enumerate}').replace('</ol>', '\\end{enumerate}')
    instr = instr.replace('<ul>', '\\begin{itemize}').replace('</ul>', '\\end{itemize}')
    instr = instr.replace('<sub>', '\\textsubscript{').replace('</sub>', '}')
    instr = instr.replace('<sup>', '\\textsuperscript{').replace('</sup>', '}')
    instr = instr.replace('<blockquote>', '\\begin{quote}').replace('</blockquote>', '\\end{quote}')
    instr = instr.replace('<em>', '{\\em ').replace('</em>', '}')
    instr = instr.replace('<strong>', '{\\bfseries ').replace('</strong>', '}')
    instr = instr.replace('%', '\percent')# note that the utf8_clean function re-replaces this with \%
    return  instr
