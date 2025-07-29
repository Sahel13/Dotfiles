local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
  s(
    { trig = "beg", dscr = "Generic environment", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{<>}
          <>
        \end{<>}
      ]],
      { i(1), i(0), rep(1) }
    )
  ),
  s(
    { trig = "def", dscr = "Definition" },
    fmta(
      [[
        \begin{definition}[<>]
          <>
        \end{definition}
      ]],
      { i(1), i(2) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "template", dscr = "Base template for new documents" },
    fmta(
      [[
        \documentclass[12pt, a4paper]{article}

        \usepackage{graphicx}
        \usepackage{amsmath,amssymb,amsthm,mathtools}
        \mathtoolsset{showonlyrefs} % Only show referenced equations.

        % Adjust the margins
        \usepackage{geometry}
        \geometry{
          margin=3.5cm,
        }

        % Hyperlink support.
        \usepackage[breaklinks,colorlinks]{hyperref}

        % Configure BibLaTeX.
        \usepackage[
        style=authoryear-comp,
        sorting=nyt,
        dashed=false,
        natbib=true,
        maxbibnames=5,
        maxcitenames=2,
        giveninits=true,
        uniquename=minyearinit,
        ]{biblatex}
        % Print last name first in the bibliography.
        \DeclareNameAlias{author}{family-given} 
        % Don't print "In:" for the article type.
        \renewbibmacro{in:}{%
          \ifentrytype{article}{}{\printtext{\bibstring{in}\intitlepunct}}}
        \addbibresource{references.bib}

        % Custom commands
        \DeclarePairedDelimiter\abs{\lvert}{\rvert}
        \DeclarePairedDelimiter\norm{\lVert}{\rVert}
        \DeclareMathOperator*{\argmin}{arg\,min}
        \DeclareMathOperator*{\argmax}{arg\,max}
        \newcommand{\dd}{\mathrm{d}}

        \title{<>}
        \author{Sahel Iqbal}
        \date{\today}

        \begin{document}
        \maketitle

        <>

        \printbibliography

        \end{document}
      ]],
      { i(1), i(0) }
    )
  ),
  -- Sectioning commands.
  s({ trig = "sec", dscr = "Section" }, fmta("\\section{<>}", { i(1) }), { condition = line_begin }),
  s({ trig = "sub", dscr = "Subsection" }, fmta("\\subsection{<>}", { i(1) }), { condition = line_begin }),

  -- Lists.
  s(
    { trig = "ite", dscr = "Unordered list" },
    fmta(
      [[
        \begin{itemize}
          \item <>
        \end{itemize}
      ]],
      { i(1) }
    )
  ),
  s(
    { trig = "enu", dscr = "Ordered list" },
    fmta(
      [[
        \begin{enumerate}
          \item <>
        \end{enumerate}
      ]],
      { i(1) }
    )
  ),

  -- Text formatting commands.
  s({ trig = "bf", dscr = "\\textbf" }, fmta("\\textbf{<>}", { i(1) })),
  s({ trig = "em", dscr = "\\emph" }, fmta("\\emph{<>}", { i(1) })),
  s({ trig = "til", dscr = "\\tilde" }, fmta("\\tilde{<>}", { i(1) })),

  -- Spacing commands
  s({ trig = "vsp", dscr = "\\vspace" }, fmta("\\vspace{<>}", { i(1, "1ex") })),

  -- Citation commands.
  s({ trig = "tc", dscr = "\\textcite" }, fmta("\\textcite{<>}", { i(1) })),
  s({ trig = " pc", dscr = "\\parencite", wordTrig = false, regTrig = true }, fmta("~\\parencite{<>}", { i(1) })),

  -- Beamer commands.
  s(
    { trig = "frame", dscr = "Frame" },
    fmta(
      [[
        \begin{frame}{<>}
          <>
        \end{frame}
      ]],
      { i(1), i(0) }
    )
  ),
  -- LaTeX Zettelkasten
  s(
    { trig = "zet", dscr = "Zettelkasten" },
    fmta(
      [[
        \documentclass{zettelkasten}
        \notetitle{<>}
        \notedate{<>}
        \begin{document}

        <>

        % \seealso \zl{}
        \end{document}
      ]],
      { i(1), i(2), i(0) }
    )
  ),
}
