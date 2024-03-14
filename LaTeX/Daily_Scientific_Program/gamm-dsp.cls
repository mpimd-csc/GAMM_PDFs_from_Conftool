%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAMM book of abstracts class                                                 %
% Written by Jens Saak, March 2024                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gamm-dsp}[2024/03/18 GAMM scientifc program class]

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
\titleformat{\chapter}[display]{\normalfont\bfseries}{}{0pt}{\raggedleft\color{primary}\Huge\bfseries}


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
\newcommand{\white}[1]{\textcolor{white}{\Large\bfseries #1}}


% Load this year's base information
\RequirePackage{../this-gamm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of authors is generated as index                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{multicol,imakeidx}
\makeindex[columns=4, title=Alphabetical Speaker Index, intoc]
\newcommand{\presenter}[1]{\textit{#1}\index{#1}}

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

\RequirePackage{longtable, ragged2e, tabularx}
\newcolumntype{A}{>{\RaggedRight}p{23.1cm}}
\newcolumntype{T}{>{\RaggedRight\cellcolor{secondary!20}}p{7.42cm}}
\newcolumntype{B}{>{\RaggedRight}p{5.465cm}}
\newcolumntype{C}{>{\RaggedRight\leavevmode\color{white}\columncolor{tertiary}}B}
\newcolumntype{X}{>{\RaggedRight}p{3.5cm}}
\newcolumntype{Y}{>{\RaggedRight\leavevmode\color{white}\columncolor{tertiary}}X}
\newcolumntype{x}{>{\RaggedRight}p{7.4cm}}
\newcolumntype{t}{>{\RaggedRight\cellcolor{secondary!20}}p{15.22cm}}
\newcolumntype{y}{>{\RaggedRight\leavevmode\color{white}\columncolor{tertiary}}x}
\newcolumntype{P}{>{\columncolor{primary}}m{2cm}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page and maketitle                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{../Common/gamm-titlepage}
\renewcommand{\maketitle}{\gammtitle{Daily Scientific Program}}
\AtBeginDocument{%
  \begin{landscape}
    \maketitle
  \end{landscape}
  \renewcommand{\arraystretch}{1.5}
}
