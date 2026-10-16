-- Monolith: black, greys and white with one concrete accent, the SARBS
-- palette. The colors are greys with faint tints taken from the wallpaper:
-- dusk sky for strings, storm clouds for types, concrete for the
-- preprocessor. Structure stays grey: bold keywords, white functions, dark
-- comments. The same colors are in foot, Waybar, mako and the Helix theme.
vim.cmd.highlight("clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd.syntax("reset")
end

vim.o.background = "dark"
vim.g.colors_name = "monolith"

local c = {
	bg = "#121212",
	bg1 = "#1e1e1e",
	bg2 = "#2a2a2a",
	bg3 = "#3a3a3a",
	line_nr = "#424242",
	grey = "#4a4a4a",
	comment = "#5a5a5a",
	muted = "#7a7a7a",
	keyword = "#9a9a9a",
	fg = "#d0d0d0",
	fg_bright = "#ececec",

	accent = "#8a7d74", -- concrete
	selection = "#3a3633",
	string = "#c2aeb0", -- dusk sky
	number = "#a99bb0", -- mauve
	type = "#8b97ab", -- storm clouds
	preproc = "#a39184", -- concrete, lighter
	green = "#9aa391",
	water = "#8c9c9e",
	warning = "#b3a48a", -- the ledge
	error = "#a8665e", -- brick
}
local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.bg1 })
hi("NormalNC", { fg = c.fg, bg = c.bg })
hi("SignColumn", { fg = c.fg, bg = c.bg })
hi("EndOfBuffer", { fg = c.bg, bg = c.bg })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.bg1 })
hi("CursorColumn", { bg = c.bg1 })
hi("ColorColumn", { bg = c.bg1 })
hi("Visual", { bg = c.selection })
hi("VisualNOS", { bg = c.selection })
hi("Search", { fg = c.fg_bright, bg = "#4a433e" })
hi("IncSearch", { fg = c.bg, bg = c.accent, bold = true })
hi("CurSearch", { fg = c.bg, bg = c.accent, bold = true })
hi("Substitute", { fg = c.bg, bg = c.accent })
hi("MatchParen", { fg = c.fg_bright, bg = c.bg3, bold = true })
hi("NonText", { fg = c.bg3 })
hi("Whitespace", { fg = c.bg3 })

-- Line numbers and folds
hi("LineNr", { fg = c.line_nr, bg = c.bg })
hi("CursorLineNr", { fg = c.accent, bg = c.bg1, bold = true })
hi("FoldColumn", { fg = c.grey, bg = c.bg })
hi("Folded", { fg = c.muted, bg = c.bg1, italic = true })

-- Window separators and borders
hi("WinSeparator", { fg = c.bg3, bg = c.bg })
hi("VertSplit", { fg = c.bg3, bg = c.bg })
hi("FloatBorder", { fg = c.bg3, bg = c.bg1 })
hi("FloatTitle", { fg = c.fg_bright, bg = c.bg1, bold = true })

-- Statusline and tabline
hi("StatusLine", { fg = c.fg, bg = c.bg2 })
hi("StatusLineNC", { fg = c.muted, bg = c.bg1 })
hi("TabLine", { fg = c.muted, bg = c.bg1 })
hi("TabLineFill", { fg = c.muted, bg = c.bg1 })
hi("TabLineSel", { fg = c.bg, bg = c.accent, bold = true })

-- Menus and prompts
hi("Pmenu", { fg = c.fg, bg = c.bg1 })
hi("PmenuSel", { fg = c.bg, bg = c.accent, bold = true })
hi("PmenuSbar", { bg = c.bg2 })
hi("PmenuThumb", { bg = c.grey })
hi("WildMenu", { fg = c.bg, bg = c.accent })
hi("Question", { fg = c.fg_bright })
hi("MoreMsg", { fg = c.fg_bright })
hi("ModeMsg", { fg = c.fg_bright })
hi("ErrorMsg", { fg = c.error, bold = true })
hi("WarningMsg", { fg = c.warning })
hi("Title", { fg = c.fg_bright, bold = true })
hi("Directory", { fg = c.type, bold = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.error })
hi("DiagnosticWarn", { fg = c.warning })
hi("DiagnosticInfo", { fg = c.type })
hi("DiagnosticHint", { fg = c.water })

hi("DiagnosticUnderlineError", { undercurl = true, sp = c.error })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warning })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.type })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.water })

-- Diff
hi("DiffAdd", { fg = c.green, bg = "#1f231d" })
hi("DiffChange", { fg = c.type, bg = "#1d2027" })
hi("DiffDelete", { fg = c.error, bg = "#2a1d1b" })
hi("DiffText", { fg = c.fg_bright, bg = "#2f3440" })

-- Spelling
hi("SpellBad", { undercurl = true, sp = c.error })
hi("SpellCap", { undercurl = true, sp = c.type })
hi("SpellLocal", { undercurl = true, sp = c.water })
hi("SpellRare", { undercurl = true, sp = c.number })

-- Core syntax
hi("Comment", { fg = c.comment, italic = true })

hi("Constant", { fg = c.number })
hi("String", { fg = c.string })
hi("Character", { fg = c.string })
hi("Number", { fg = c.number })
hi("Boolean", { fg = c.number })
hi("Float", { fg = c.number })

hi("Identifier", { fg = c.fg })
hi("Variable", { fg = c.fg })
hi("Function", { fg = c.fg_bright })

hi("Statement", { fg = c.keyword, bold = true })
hi("Conditional", { fg = c.keyword, bold = true })
hi("Repeat", { fg = c.keyword, bold = true })
hi("Label", { fg = c.keyword, bold = true })
hi("Operator", { fg = c.muted })
hi("Keyword", { fg = c.keyword, bold = true })
hi("Exception", { fg = c.keyword, bold = true })

hi("PreProc", { fg = c.preproc })
hi("Include", { fg = c.preproc })
hi("Define", { fg = c.preproc })
hi("Macro", { fg = c.preproc })

hi("Type", { fg = c.type })
hi("StorageClass", { fg = c.keyword, bold = true })
hi("Structure", { fg = c.keyword, bold = true })
hi("Typedef", { fg = c.keyword, bold = true })

hi("Special", { fg = c.water })
hi("Delimiter", { fg = c.muted })
hi("SpecialComment", { fg = c.comment, italic = true })

hi("Error", { fg = c.fg_bright, bg = "#6e3a35", bold = true })
hi("Todo", { fg = c.bg, bg = c.accent, bold = true })

-- Tree-sitter captures
hi("@comment",               { link = "Comment" })
hi("@string",                { link = "String" })
hi("@string.escape",         { fg = c.water })
hi("@character",             { link = "Character" })

hi("@number",                { link = "Number" })
hi("@float",                 { link = "Float" })
hi("@boolean",               { link = "Boolean" })
hi("@constant",              { link = "Constant" })
hi("@constant.builtin",      { fg = c.number })

hi("@variable",              { fg = c.fg })
hi("@variable.builtin",      { fg = c.number })
hi("@variable.parameter",    { fg = c.fg })

hi("@function",              { fg = c.fg_bright })
hi("@function.call",         { fg = c.fg_bright })
hi("@function.builtin",      { fg = c.type })
hi("@method",                { fg = c.fg_bright })
hi("@method.call",           { fg = c.fg_bright })

hi("@keyword",               { fg = c.keyword, bold = true })
hi("@keyword.function",      { fg = c.keyword, bold = true })
hi("@keyword.return",        { fg = c.keyword, bold = true })
hi("@keyword.operator",      { fg = c.keyword, bold = true })

hi("@type",                  { fg = c.type })
hi("@type.builtin",          { fg = c.type })
hi("@attribute",             { fg = c.preproc })
hi("@property",              { fg = c.fg })

hi("@operator",              { fg = c.muted })
hi("@punctuation.delimiter", { fg = c.muted })
hi("@punctuation.bracket",   { fg = c.muted })

hi("@tag",                   { fg = c.keyword, bold = true })
hi("@tag.attribute",         { fg = c.type })
hi("@markup.heading",        { fg = c.fg_bright, bold = true })
hi("@markup.link",           { fg = c.string, underline = true })
