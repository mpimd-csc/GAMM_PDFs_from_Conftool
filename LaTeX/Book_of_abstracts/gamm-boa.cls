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
    linkcolor  = linkBlue,
    citecolor  = linkRed,
    urlcolor   = linkPurple,
    pdfpagelabels
  ]{hyperref}
\fi

\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[ngerman,american]{babel}

\RequirePackage{../Common/gamm-titlepage}
\renewcommand{\maketitle}{\gammtitle{Book of Abstracts}}

\let\oldchapter\chapter%
\let\oldsection\section%
\let\oldsubsection\subsection%


\AtBeginDocument{\maketitle}
