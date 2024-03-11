%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAMM book of abstracts class                                                 %
% Written by Jens Saak, March 2024                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gamm-boa}[2024/03/18 GAMM book of abstracts class]

% pick report as th base class
\LoadClass[10pt, oneside]{report}
\setlength{\parskip}{1.0ex plus0.45ex minus0.45ex}
\setlength{\parindent}{0em}
\RequirePackage{geometry}
\geometry{
  a4paper,
  landscape,
  total={257mm,170mm},
  left=20mm,
  top=20mm,
}
\RequirePackage[raggedleft]{titlesec}
\titleformat{\chapter}[display]
  {\normalfont\bfseries}{}{0pt}{\raggedleft\color{primary}\Huge\bfseries}
\makeatletter
\renewcommand{\@pnumwidth}{2em} % avoid overfull page number boxes in TOC
\renewcommand{\@tocrmarg}{.2em}
\makeatother
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Class options                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifhidelinks\hidelinksfalse%
\DeclareOption{hidelinks}{\colorlinksfalse\hidelinkstrue}

\newif\ifcolorlinks\colorlinkstrue%
\DeclareOption{colorlinks}{\colorlinkstrue}

\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Style and packages                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% switch to OpenSans font as the default
\RequirePackage[default, scale=.95]{opensans}

% colors and colored tables
\RequirePackage[table]{xcolor}

% Load this year's base information
\RequirePackage{../this-gamm}

\ifhidelinks%
  \RequirePackage[%
    colorlinks = false,
    hidelinks,
    pdfpagelabels
  ]{hyperref}
\fi

\ifcolorlinks%
  \RequirePackage[%
  colorlinks = true,
  linkcolor = primary,
  pdfpagelabels
  ]{hyperref}
\fi

\RequirePackage{pdflscape}

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman,american]{babel}

\RequirePackage{ltxtable}
\usepackage{makeidx}
\makeindex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page and maketitle                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{../Common/gamm-titlepage}
\renewcommand{\maketitle}{\gammtitle{Daily Session Plan}}
\AtBeginDocument{%
  \begin{landscape}
    \maketitle
  \end{landscape}
}
