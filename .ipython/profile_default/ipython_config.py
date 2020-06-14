from pygments import token

c = get_config()  # type: ignore # noqa # pylint:disable=E0602

c.InteractiveShellApp.extensions = ["autoreload"]

# display full output, not only last result?
c.InteractiveShell.ast_node_interactivity = "all"
# c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.true_color = True

# https://github.com/rakr/vim-one/blob/master/colors/one.vim
mono_1 = "#abb2bf"
mono_2 = "#828997"
mono_3 = "#5c6370"
mono_4 = "#4b5263"
hue_1 = "#56b6c2"
hue_2 = "#61afef"
hue_3 = "#c678dd"
hue_4 = "#98c379"
hue_5 = "#e06c75"
hue_5_2 = "#be5046"
hue_6 = "#d19a66"
hue_6_2 = "#e5c07b"
syntax_bg = "#282c34"
syntax_gutter = "#636d83"
syntax_cursor = "#2c323c"
syntax_accent = "#528bff"
vertsplit = "#181a1f"
special_grey = "#3b4048"
visual_grey = "#3e4452"
pmenu = "#333841"
syntax_fg = mono_1
syntax_fold_bg = mono_3


c.TerminalInteractiveShell.highlighting_style_overrides = {
    token.Text: syntax_fg,
    token.Comment: mono_3,
    token.Keyword: f"{hue_3} nobold",
    token.Keyword.Constant: hue_4,
    token.Name: f"{syntax_fg} nobold",
    token.Name.Class: f"{hue_2} nobold",
    token.Name.Function: hue_2,
    token.Name.Namespace: f"{syntax_fg} nobold",
    token.Name.Decorator: hue_2,
    token.Name.Exception: f"{hue_6_2} nobold",
    token.Number: hue_6,
    token.String: hue_4,
    token.String.Escape: f"{hue_2} nobold",
    token.Literal.String.Interpol: f'{hue_2} nobold',
    token.Literal.String.Doc: hue_4,
    token.Name.Builtin: hue_6_2,
    token.Name.Builtin.Pseudo: hue_5,  # self
    token.Operator: hue_3,
    token.Operator.Word: f'{hue_3} nobold',
    token.Punctuation: syntax_fg,

    token.Token.Prompt: hue_4,
    token.Token.PromptNum: f'{hue_4} bold',
    token.Token.OutPrompt: hue_6,
    token.Token.OutPromptNum: f'{hue_6} bold',
}
