vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd.syntax("reset")
end

vim.o.background = "dark"
vim.g.colors_name = "gruvbox"

local c = {
	bg0_hard = "#1d2021",
	bg0 = "#282828",
	bg1 = "#3c3836",
	bg2 = "#504945",
	bg3 = "#665c54",
	fg = "#ebdbb2",
	fg0 = "#fbf1c7",
	fg4 = "#a89984",
	gray = "#928374",

	red = "#fb4934",
	green = "#b8bb26",
	yellow = "#fabd2f",
	blue = "#83a598",
	purple = "#d3869b",
	aqua = "#8ec07c",
	orange = "#fe8019",

	dark_red = "#cc241d",
	dark_yellow = "#d79921",
}
local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = c.fg, bg = c.bg0 })
hi("NormalFloat", { fg = c.fg, bg = c.bg1 })
hi("NormalNC", { fg = c.fg, bg = c.bg0 })
hi("SignColumn", { fg = c.fg, bg = c.bg0 })
hi("EndOfBuffer", { fg = c.bg0, bg = c.bg0 })
hi("Cursor", { fg = c.bg0, bg = c.fg })
hi("CursorLine", { bg = c.bg1 })
hi("CursorColumn", { bg = c.bg1 })
hi("ColorColumn", { bg = c.bg1 })
hi("Visual", { bg = c.bg3 })
hi("VisualNOS", { bg = c.bg3 })
hi("Search", { fg = c.bg0, bg = c.yellow })
hi("IncSearch", { fg = c.bg0, bg = c.orange })
hi("CurSearch", { fg = c.bg0, bg = c.orange })
hi("Substitute", { fg = c.bg0, bg = c.orange })
hi("MatchParen", { bg = c.bg3, bold = true })
hi("NonText", { fg = c.bg2 })
hi("Whitespace", { fg = c.bg2 })

-- Line numbers and folds
hi("LineNr", { fg = c.bg3, bg = c.bg0 })
hi("CursorLineNr", { fg = c.yellow, bg = c.bg1, bold = true })
hi("FoldColumn", { fg = c.gray, bg = c.bg0 })
hi("Folded", { fg = c.gray, bg = c.bg1, italic = true })

-- Window separators and borders
hi("WinSeparator", { fg = c.bg3, bg = c.bg0 })
hi("VertSplit", { fg = c.bg3, bg = c.bg0 })
hi("FloatBorder", { fg = c.fg4, bg = c.bg1 })
hi("FloatTitle", { fg = c.yellow, bg = c.bg1, bold = true })

-- Statusline and tabline
hi("StatusLine", { fg = c.fg, bg = c.bg2 })
hi("StatusLineNC", { fg = c.fg4, bg = c.bg1 })
hi("TabLine", { fg = c.fg4, bg = c.bg1 })
hi("TabLineFill", { fg = c.fg4, bg = c.bg1 })
hi("TabLineSel", { fg = c.bg0, bg = c.dark_yellow, bold = true })

-- Menus and prompts
hi("Pmenu", { fg = c.fg, bg = c.bg1 })
hi("PmenuSel", { fg = c.bg0, bg = c.dark_yellow, bold = true })
hi("PmenuSbar", { bg = c.bg2 })
hi("PmenuThumb", { bg = c.fg4 })
hi("WildMenu", { fg = c.bg0, bg = c.yellow })
hi("Question", { fg = c.orange })
hi("MoreMsg", { fg = c.yellow })
hi("ModeMsg", { fg = c.yellow })
hi("ErrorMsg", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.orange })
hi("Title", { fg = c.green, bold = true })
hi("Directory", { fg = c.green, bold = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.aqua })

hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.aqua })

-- Diff
hi("DiffAdd", { fg = c.green, bg = "#32361a" })
hi("DiffChange", { fg = c.aqua, bg = "#283a32" })
hi("DiffDelete", { fg = c.red, bg = "#3c1f1e" })
hi("DiffText", { fg = c.bg0, bg = c.yellow })

-- Spelling
hi("SpellBad", { undercurl = true, sp = c.red })
hi("SpellCap", { undercurl = true, sp = c.blue })
hi("SpellLocal", { undercurl = true, sp = c.aqua })
hi("SpellRare", { undercurl = true, sp = c.purple })

-- Core syntax
hi("Comment", { fg = c.gray, italic = true })

hi("Constant", { fg = c.purple })
hi("String", { fg = c.green })
hi("Character", { fg = c.purple })
hi("Number", { fg = c.purple })
hi("Boolean", { fg = c.purple })
hi("Float", { fg = c.purple })

hi("Identifier", { fg = c.blue })
hi("Variable", { fg = c.fg })
hi("Function", { fg = c.green, bold = true })

hi("Statement", { fg = c.red })
hi("Conditional", { fg = c.red })
hi("Repeat", { fg = c.red })
hi("Label", { fg = c.red })
hi("Operator", { fg = c.fg })
hi("Keyword", { fg = c.red })
hi("Exception", { fg = c.red })

hi("PreProc", { fg = c.aqua })
hi("Include", { fg = c.aqua })
hi("Define", { fg = c.aqua })
hi("Macro", { fg = c.aqua })

hi("Type", { fg = c.yellow })
hi("StorageClass", { fg = c.orange })
hi("Structure", { fg = c.aqua })
hi("Typedef", { fg = c.yellow })

hi("Special", { fg = c.orange })
hi("Delimiter", { fg = c.fg4 })
hi("SpecialComment", { fg = c.gray, italic = true })

hi("Error", { fg = c.fg0, bg = c.dark_red, bold = true })
hi("Todo", { fg = c.bg0, bg = c.yellow, bold = true })

-- Tree-sitter captures
hi("@comment",               { link = "Comment" })
hi("@string",                { link = "String" })
hi("@string.escape",         { fg = c.orange })
hi("@character",             { link = "Character" })

hi("@number",                { link = "Number" })
hi("@float",                 { link = "Float" })
hi("@boolean",               { link = "Boolean" })
hi("@constant",              { link = "Constant" })
hi("@constant.builtin",      { fg = c.purple })

hi("@variable",              { fg = c.fg })
hi("@variable.builtin",      { fg = c.orange })
hi("@variable.parameter",    { fg = c.blue })

hi("@function",              { fg = c.green, bold = true })
hi("@function.call",         { fg = c.green })
hi("@function.builtin",      { fg = c.yellow })
hi("@method",                { fg = c.green, bold = true })
hi("@method.call",           { fg = c.green })

hi("@keyword",               { fg = c.red })
hi("@keyword.function",      { fg = c.red })
hi("@keyword.return",        { fg = c.red, bold = true })
hi("@keyword.operator",      { fg = c.red })

hi("@type",                  { fg = c.yellow })
hi("@type.builtin",          { fg = c.yellow })
hi("@attribute",             { fg = c.aqua })
hi("@property",              { fg = c.blue })

hi("@operator",              { fg = c.fg })
hi("@punctuation.delimiter", { fg = c.fg4 })
hi("@punctuation.bracket",   { fg = c.fg4 })

hi("@tag",                   { fg = c.aqua })
hi("@tag.attribute",         { fg = c.yellow })
hi("@markup.heading",        { fg = c.green, bold = true })
hi("@markup.link",           { fg = c.blue, underline = true })
