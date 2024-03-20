%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAMM book of abstracts class                                                 %
% Written by Jens Saak, March 2024                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gamm-boa}[2024/03/18 GAMM book of abstracts class]

% pick report as th base class
\LoadClass[11pt, oneside]{report}
\setlength{\parskip}{1.0ex plus0.45ex minus0.45ex}
\setlength{\parindent}{0em}
\RequirePackage{geometry}
\geometry{
  a4paper,
  total={170mm,257mm},
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

% colors
\RequirePackage{xcolor}

% Load this year's base information
\RequirePackage{../this-gamm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of authors is generated as index                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{multicol,imakeidx}
\makeindex[title=Alphabetical Speaker Index, intoc]
\newcommand{\presenter}[1]{\underline{#1}\index{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hyperref for clickable links                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman,american]{babel}

\RequirePackage{tabularx}
\RequirePackage{ifthen}
\RequirePackage{amsmath, amsfonts, amssymb}
\RequirePackage{upgreek}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page and maketitle                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{../Common/gamm-titlepage}
\renewcommand{\maketitle}{\gammtitle{Book of Abstracts}}
\AtBeginDocument{\maketitle}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sectioning commands                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\Headline}[3]{%
{\bfseries\large#3}\phantomsection\addcontentsline{toc}{#1}{\small#2}{}{}%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plenary Event section macros with 9 arguments                                %
%                                                                              %
% 1. title                                                                     %
% 2. session                                                                   %
% 3. speaker                                                                   %
% 4. date                                                                      %
% 5. starting time                                                             %
% 6. ending time                                                               %
% 7. room                                                                      %
% 8. laudatory / session chair                                                 %
% 9. abstract                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlength{\fboxsep}{1ex}
\newlength{\tablewidth}\setlength{\tablewidth}{\textwidth-2\fboxsep-2\fboxrule}
\newcommand{\Prandtl}[9]{%
  \colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Laudation:}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{section}{#2:~#1~(#3)}{#2:~#1}}\\
      Speaker:    & {\bfseries #3}\\
      Date:       & #4\hfill #5--#6\\
      Room:       & #7
      \ifthenelse{\equal{#8}{}}{}{\\Laudation: & \small #8}
    \end{tabularx}%
  }%
  \par\nopagebreak%
  {\sloppy #9}%
  \vspace*{\stretch{1}}%
  \par%
}%

\newcommand{\Plenary}[9]{%
  \pagebreak[0]%
  \colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Laudation:}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{section}{#2:~#1~(#3)}{#2:~#1}}\\
      Speaker:    & {\bfseries #3}\\
      Date:       & #4\hfill #5--#6\\
      Room:       & #7
      \ifthenelse{\equal{#8}{}}{}{\\Chair:  & \small #8}
    \end{tabularx}%
  }%
  \par\nopagebreak%
  {\sloppy #9}%
  \vspace*{\stretch{1}}%
  \par%
}%

\newcommand{\Mises}[8]{%
  \colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Laudation:}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{section}{#2:~#1~(#3)}{#2:~#1}}\\
      Speaker:    & {\bfseries #3}\\
      Date:       & #4\hfill #5--#6\\
      Room:       & #7
      \ifthenelse{\equal{#8}{}}{}{\\Laudation: & \small #8}
    \end{tabularx}%
  }%
  \par%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section macro with 2 arguments                                               %
%                                                                              %
% 1. section title                                                             %
% 2. section organizers                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\Section}[2]{%
  \pagebreak[1]%
  \colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Organizer(s):~}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{section}{#1}{#1}}\\
      Organizer(s):   & \small #2
    \end{tabularx}%
  }%
  \par\nopagebreak%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Session macro with 7 arguments                                               %
%                                                                              %
% 1. session number                                                            %
% 2. session name                                                              %
% 3. date                                                                      %
% 4. starting time                                                             %
% 5. ending time                                                               %
% 6. room                                                                      %
% 7. chairs                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\Session}[7]{%
  \colorbox{secondary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Chair(s):}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{subsection}{#1: #2 (#6)}{#1:~#2}}\\
      Date:           & #3\hfill #4--#5\\
      Room:           & #6
      \ifthenelse{\equal{#7}{}}{}{\\Chair(s):  & \small #7}
    \end{tabularx}%
  }%
  \par\nopagebreak%
}%
%
\newcommand{\SSession}[7]{%
  \colorbox{secondary}{%
    \color{white}%
    \begin{tabularx}{\tablewidth}{@{}p{\widthof{Chair(s):}}X@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{\bfseries#1:~#2}\\
      Date:           & #3\hfill #4--#5\\
      Room:           & #6
      \ifthenelse{\equal{#7}{}}{}{\\Chair(s):  & \small #7}
    \end{tabularx}%
  }%
  \par\nopagebreak%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contribution macro with 5 arguments                                          %
%                                                                              %
% 1. tile                                                                      %
% 2. authors                                                                   %
% 3. starting time                                                             %
% 4. organizations                                                             %
% 5. abstract                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{ragged2e}
\newcommand{\Contribution}[5]{%
  \pagebreak[0]%
  \colorbox{tertiary}{%
    \begin{tabularx}{\tablewidth}{@{}Xp{\widthof{#3}}@{}}
      \multicolumn{2}{@{}p{\tablewidth}@{}}{%
      \Headline{subsubsection}{#1}{\normalsize#1}}\\
      \RaggedRight\small#2 & #3\\
      \RaggedRight\small\textit{#4} &
    \end{tabularx}%
  }% end of colorbox
  \par\nopagebreak%
  {\sloppy #5}%
  \vspace*{\stretch{1}}%
  \par%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input path for Contributions                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\def\input@path{{./Sessions/}}
%or: \def\input@path{{/path/to/folder/}{/path/to/other/folder/}}
\makeatother
