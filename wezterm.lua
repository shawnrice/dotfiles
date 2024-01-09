-- @see https://hackernoon.com/get-the-most-out-of-your-terminal-a-comprehensive-guide-to-wezterm-configuration

-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

--- Config struct documentation
-- https://wezfurlong.org/wezterm/config/lua/config/index.html
-- This table will hold the configuration.

-- Use the config_builder which will help provide clearer error messages
local config = wezterm.config_builder()

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

--
-- Key assignments
--

-- Defaults: https://wezfurlong.org/wezterm/config/default-keys.html

--
-- Hyperlinks
--

-- https://wezfurlong.org/wezterm/hyperlinks.html

-- Terminal hyperlinks
-- https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
-- printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'

-- Use the defaults as a base.  https://wezfurlong.org/wezterm/config/lua/config/hyperlink_rules.html
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)

-- Regex syntax:  https://docs.rs/regex/latest/regex/#syntax and https://docs.rs/fancy-regex/latest/fancy_regex/#syntax
-- Lua's [[ ]] literal strings prevent character [[:classes:]] :(
-- To avoid "]]] at end, use "[a-z].{0}]]"
-- https://www.lua.org/pil/2.4.html#:~:text=bracketed%20form%20may%20run%20for%20several%20lines%2C%20may%20nest

table.insert(config.hyperlink_rules, {
	-- https://github.com/shinnn/github-username-regex  https://stackoverflow.com/a/64147124/5353461
	regex = [[(^|(?<=[\[(\s'"]))([0-9A-Za-z][-0-9A-Za-z]{0,38})/([A-Za-z0-9_.-]{1,100})((?=[])\s'".!?])|$)]],
	--  is/good  0valid0/-_.reponname  /bad/start  -bad/username  bad/end!  too/many/parts -bad/username
	--  [wraped/name] (aa/bb) 'aa/bb' "aa/bb"  end/punct!  end/punct.
	format = "https://www.github.com/$2/$3/",
	-- highlight = 0,  -- highlight this regex match group, use 0 for all
})

--
-- Fonts
--
-- https://wezfurlong.org/wezterm/config/lua/wezterm/font.html
-- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
-- wezterm ls-fonts
-- wezterm ls-fonts --list-system

-- Monaspace:  https://monaspace.githubnext.com/
-- @see  https://gist.github.com/ErebusBat/9744f25f3735c1e0491f6ef7f3a9ddc3

-- @see https://github.com/githubnext/monaspace#coding-ligatures
local ligature_features = {
	-- @see https://learn.microsoft.com/en-us/typography/opentype/spec/features_ae#tag-calt
	"calt", -- context alternatives
	-- @see https://learn.microsoft.com/en-us/typography/opentype/spec/features_ae#tag-clig
	"clig", -- contextual ligatures
	"liga", -- ligatures
	"dlig", -- discretionary ligatures
	"ss01", -- ss01: ligatures related to the equals glyph like != and ===.
	"ss02", -- ss02: ligatures related to the greater than or less than operators.
	"ss03", -- ss03: ligatures related to arrows like -> and =>.
	"ss04", -- ss04: ligatures related to markup, like </ and />.
	"ss05", -- ss05: ligatures related to the F# programming language, like |>.
	"ss06", -- ss06: ligatures related to repeated uses of # such as ## or ###.
	"ss07", -- ss07: ligatures related to the asterisk like ***.
	"ss08", -- ss08: ligatures related to combinations like .= or .-.
	"ssty", -- math script style alternatives
	"zero", -- slashed zero
}

config.font = wezterm.font_with_fallback({
	{
		family = "Monaspace Argon Var",
		weight = "Regular",
		harfbuzz_features = ligature_features,
	},
	"JetBrains Mono",
	"Noto Color Emoji",
	-- 'Fira Code',
	-- 'Operator Mono Lig',
	-- 'Monoid',
	-- 'Monoisome',
	-- 'Menlo',
	-- 'Hack',
	-- 'JetBrains Mono',
	-- 'monospace',
})

config.font_size = 10.85
config.line_height = 1.16
config.warn_about_missing_glyphs = true

-- @see https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
config.freetype_load_target = "HorizontalLcd"

-- @see https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
config.font_rules = {
	--
	-- Italic (comments)
	--
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Radon",
			weight = "ExtraLight",
			stretch = "Normal",
			style = "Normal",
			harfbuzz_features = ligature_features,
		}),
	},

	--
	-- Bold (highlighting)
	--
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font({
			family = "Monaspace Neon",
			weight = "Medium",
			stretch = "Normal",
			style = "Normal",
			harfbuzz_features = ligature_features,
		}),
	},

	--
	-- Bold Italic
	--
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Xenon",
			style = "Italic",
			weight = "Bold",
			harfbuzz_features = ligature_features,
		}),
	},
}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Material (base16)'
-- config.color_scheme = 'MaterialDarker'
-- config.color_scheme = 'Material Darker (base16)'
-- config.color_scheme = "MaterialDesignColors"
-- config.color_scheme = "Mikado (terminal.sexy)"
config.color_scheme = "Hardcore"
-- config.color_scheme = 'Codeschool (dark) (terminal.sexy)'

--
-- Miscellaneous
--

local misc = {
	adjust_window_size_when_changing_font_size = false,
	check_for_updates = true,
	check_for_updates_interval_seconds = 86400,
	enable_scroll_bar = true,
	exit_behavior = "CloseOnCleanExit", -- Use 'Hold' to not close
	hide_tab_bar_if_only_one_tab = true,
	initial_cols = 140,
	initial_rows = 40,
	quote_dropped_files = "Posix",
	switch_to_last_active_tab_when_closing_tab = true,
	use_fancy_tab_bar = true,
	window_decorations = "RESIZE",
}

for k, v in pairs(misc) do
	config[k] = v
end

-- and finally, return the configuration to wezterm
return config
