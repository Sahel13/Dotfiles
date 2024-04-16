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
  s({ trig = "sec", dscr = "Section" }, fmta("\\section{<>}", { i(1) }), { condition = line_begin }),
  s({ trig = "sub", dscr = "Subsection" }, fmta("\\subsection{<>}", { i(1) }), { condition = line_begin }),
}
