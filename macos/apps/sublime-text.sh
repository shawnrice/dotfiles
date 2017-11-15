###############################################################################
# Sublime Text                                                                #
###############################################################################

SUBLIME_SETTINGS_DIRECTORY="${HOME}/Library/Application Support/Sublime Text 3/Packages/User"

[[ ! -d "${SUBLIME_SETTINGS_DIRECTORY}" ]] && mkdir -p "${SUBLIME_SETTINGS_DIRECTORY}"

# Install Sublime Text settings
for f in $(ls ../st3 | sublime-); do
	cp "../st3/${f}" "${SUBLIME_SETTINGS_DIRECTORY}/${f}"
done


# Install Package Control
# https://packagecontrol.io/Package%20Control.sublime-package

# https://go.microsoft.com/fwlink/?LinkID=620882
read -r -d '' PACKAGE_CONTROL_SETTINGS <<'EOF'
{
	installed_packages: [
		"Alignment",
		"All Autocomplete",
		"AutocompletionFuzzy",
		"AutoFileName",
		"Babel",
		"BracketHighlighter",
		"ChangeQuotes",
		"DocBlockr",
		"Dotfiles Syntax Highlighting",
		"EditorConfig",
		"FindKeyConflicts",
		"Focus",
		"Git Config",
		"Git",
		"GitGutter",
		"Github Tools",
		"HTML5",
		"Indent XML",
		"IndentTips",
		"JSONComma",
		"Keymaps",
		"LaTeXing",
		"MarkdownEditing",
		"Material Theme - Appbar",
		"Material Theme",
		"Minify",
		"Modific",
		"nginx",
		"Non Text Files",
		"OmniMarkupPreviewer",
		"Origami",
		"Package Control",
		"plist",
		"PostgreSQL Syntax Highlighting",
		"Pretty JSON",
		"Rust Enhanced",
		"RustAutoComplete",
		"SCSS",
		"Side-by-Side Settings",
		"SideBarEnhancements",
		"SingleTrailingNewLine",
		"SublimeCodeIntel",
		"SublimeLinter",
		"SublimeLinter-contrib-eslint",
		"SublimeLinter-contrib-ruby-lint",
		"SublimeLinter-contrib-sass-lint",
		"SublimeLinter-html-tidy",
		"SublimeLinter-phpcs",
		"SublimeLinter-phpcs",
		"SublimeLinter-rubocop",
		"SyncedSidebarBg",
		"TypeScript",
		"WordCount"
	],
	channels: [],
	repositories: [
		"http://testing.latexing.com/packages.json",
	],
	auto_upgrade_ignore: [
		// List packages here to skip upgrading
	],
}
EOF

echo $PACKAGE_CONTROL_SETTINGS >> "${SUBLIME_SETTINGS_DIRECTORY}/Package Control.sublime-settings"
