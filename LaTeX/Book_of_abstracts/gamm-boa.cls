%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAMM book of abstracts class                                                 %
% Written by Jens Saak, March 2024                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gamm-boa}[2024/03/18 GAMM book of abstracts class]

% pick report as th base class
\LoadClass[10pt, a4paper, oneside]{report}
\setlength{\parskip}{1.0em plus0.45em minus0.45em}
\setlength{\parindent}{0em}
\RequirePackage{geometry}
\geometry{
  a4paper,
  total={170mm,257mm},
  left=20mm,
  top=20mm,
}
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
    pdfpagelabels
  ]{hyperref}
\fi

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman,american]{babel}

\RequirePackage{tabularx}
\RequirePackage{ifthen}
\RequirePackage{amsmath, amsfonts, amssymb}

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
  \phantomsection%
  \addcontentsline{toc}{#1}{\small#2}{}{}\textbf{\large#3}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plenary Event section macros with 6 arguments                                %
%                                                                              %
% 1. title                                                                     %
% 2. date                                                                      %
% 3. starting time                                                             %
% 4. ending time                                                               %
% 5. room                                                                      %
% 6. laudatory / session chair                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\Prandtl}[6]{%
  \setlength{\fboxsep}{0pt}\colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\textwidth}{p{\widthof{Laudation:~}}X}
      \multicolumn{2}{p{\textwidth}}{\Headline{section}{#1}{#1}}\\[.1ex]
      Date:       & #2\hfill #3-#4\\
      Room:       & #5
      \ifthenelse{\equal{#6}{}}{}{\\Laudation: & \small #6}
    \end{tabularx}}%
}%

\newcommand{\Plenary}[6]{%
  \pagebreak[0]%
  \setlength{\fboxsep}{0pt}\colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\textwidth}{p{\widthof{Chair:~}}X}
      \multicolumn{2}{p{\textwidth}}{\Headline{section}{#1}{#1}}\\[.1ex]
      Date:       & #2\hfill #3-#4\\
      Room:       & #5
      \ifthenelse{\equal{#6}{}}{}{\\Chair:  & \small #6}
    \end{tabularx}}%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section macro with 2 arguments                                               %
%                                                                              %
% 1. section title                                                             %
% 2. section organizers                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\Section}[2]{%
  \pagebreak[0]%
  \setlength{\fboxsep}{0pt}\colorbox{primary}{%
    \color{white}%
    \begin{tabularx}{\textwidth}{p{\widthof{Organizer(s):~}}X}
      \multicolumn{2}{p{\textwidth}}{\Headline{section}{#1}{#1}}\\[.1ex]
      Organizer(s):   & \small #2
    \end{tabularx}%
  }%
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
  \setlength{\fboxsep}{0pt}\colorbox{secondary}{%
    \color{white}%
    \begin{tabularx}{\textwidth}{p{\widthof{Chairs(s):~}}X}
      \multicolumn{2}{p{\textwidth}}{\Headline{subsection}{#1}{#1:#2}}\\[1mm]
      Date:           & #3\hfill #4-#5\\
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
  \setlength{\fboxsep}{0pt}\colorbox{tertiary}{%
    \begin{tabularx}{\textwidth}{Xp{\widthof{#3}}}%
      \multicolumn{2}{p{\textwidth}}{\RaggedRight\textbf{#1}}\\[.1ex]
      \RaggedRight\small#2 & #3\\
      \RaggedRight\small\textit{#4} &
    \end{tabularx}}%
  \par\nopagebreak%
  {\sloppy\small #5}%
  \vspace*{\stretch{1}}%
}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List of authors is generated as index                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{multicol,makeidx}
\makeindex
\makeatletter
\renewenvironment{theindex}{%
  \setlength{\columnsep}{3em}%
  \begin{multicols}{2}%
    \thispagestyle{plain}\parindent\z@
    \small
    \parskip\z@ \@plus .3\p@\relax
    \columnseprule \z@
    \columnsep 35\p@
    \let\item\@idxitem
  }{\end{multicols}}
\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input path for Contributions                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\def\input@path{{../Contributions/}}
%or: \def\input@path{{/path/to/folder/}{/path/to/other/folder/}}
\makeatother
