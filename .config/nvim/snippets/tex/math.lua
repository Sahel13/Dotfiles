local line_begin = require("luasnip.extras.expand_conditions").line_begin

local tex_utils = {}
tex_utils.in_math = function()
  -- This function requires the VimTeX plugin.
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex_utils.in_text = function()
  return not tex_utils.in_math()
end
return {
  s(
    { trig = "frac", dscr = "\\frac", snippetType = "autosnippet" },
    fmta("\\frac{<>}{<>}", { i(1), i(2) }),
    { condition = tex_utils.in_math }
  ),
  s({ trig = "emp", dscr = "\\emph" }, fmta("\\emph{<>}", { i(1) }), { condition = tex_utils.in_text }),
  s(
    { trig = "eq", dscr = "Equation", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{equation}
          <>
        \end{equation}
      ]],
      { i(1) }
    ),
    { condition = line_begin }
  ),
  s(
    { trig = "mm", dscr = "Inline math", wordTrig = true, snippetType = "autosnippet" },
    fmta("<>$<>$", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex_utils.in_text }
  ),
  s(
    { trig = "ali", dscr = "Aligned", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{aligned}
          <>
        \end{aligned}
      ]],
      { i(1) }
    ),
    { condition = tex_utils.in_math }
  ),
  s(
    { trig = "ali", dscr = "Align", snippetType = "autosnippet" },
    fmta(
      [[
        \begin{align}
          <>
        \end{align}
      ]],
      { i(1) }
    ),
    { condition = line_begin }
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
    { trig = "bb([%u])", dscr = "\\mathbb", regTrig = true, snippetType = "autosnippet" },
    fmta("\\mathbb{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex_utils.in_math }
  ),
  s(
    { trig = "cal([%u])", dscr = "\\mathcal", regTrig = true, snippetType = "autosnippet" },
    fmta("\\mathcal{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex_utils.in_math }
  ),
  s(
    { trig = "bf([%a])", dscr = "\\mathbf", regTrig = true, snippetType = "autosnippet" },
    fmta("\\mathbf{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex_utils.in_math }
  ),
  s(
    { trig = "hat([%a])", dscr = "\\hat", regTrig = true, snippetType = "autosnippet" },
    fmta("\\hat{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex_utils.in_math }
  ),
  s(
    { trig = "pdt", dscr = "Partial derivative w.r.t t", snippetType = "autosnippet" },
    fmta("\\frac{\\partial <>}{\\partial t}", { i(1) }),
    { condition = tex_utils.in_math }
  ),
  s(
    {
      trig = "([%a%}%)])%^t",
      dscr = "Replace t with \\top for transpose.",
      regTrig = true,
      wordTrig = false,
    },
    fmta("<>^\\top", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  -- Text commands.
  s({ trig = "bar", dscr = "\\bar" }, fmta("\\bar{<>}", { i(1) })),
  s(
    { trig = "hat([%a])", dscr = "\\hat", regTrig = true, snippetType = "autosnippet" },
    fmta("\\hat{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    }),
    { condition = tex_utils.in_math }
  ),
}
