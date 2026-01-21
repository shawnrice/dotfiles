-- @see https://hackernoon.com/get-the-most-out-of-your-terminal-a-comprehensive-guide-to-wezterm-configuration
-- @see https://github.com/MariaSolOs/dotfiles/blob/main/.config/wezterm/wezterm.lua
-- @see https://github.com/omerxx/dotfiles/blob/master/wezterm/wezterm.lua

-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux
local act = wezterm.action

-- Maximize the window on startup
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

--- Config struct documentation
-- https://wezfurlong.org/wezterm/config/lua/config/index.html
-- This table will hold the configuration.
-- Use the config_builder which will help provide clearer error messages
local config = wezterm.config_builder()

local DARK_THEME = "GruvboxDarkHard"
local LIGHT_THEME = "GruvboxLight"

function find_color_scheme()
	if (wezterm.gui.get_appearance()):find("Dark") then
		return DARK_THEME
	else
		return LIGHT_THEME
	end
end

wezterm.on("window-config-reloaded", function(window, _)
	local overrides = window:get_config_overrides() or {}
	window:set_config_overrides(find_color_scheme())
end)

config.color_scheme = find_color_scheme()

-- Remove extra space.
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Cursor.
config.cursor_thickness = "0.1cell"

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}

-- Support for undercurl, etc.
-- To make this available, you must run the following command:
-- tempfile=$(mktemp) \
--   && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
--   && tic -x -o ~/.terminfo $tempfile \
--   && rm $tempfile
-- @see https://wezfurlong.org/wezterm/config/lua/config/term.html
config.term = "wezterm"

local colors = {
	bg = "#0E1419",
	black = "#000000",
	dark_lilac = "#6D5978",
	lilac = "#BAA0E8",
}

-- config.color_scheme = 'Dracula (Official)'
-- config.colors = {
--     background = colors.bg,
--     tab_bar = {
--         inactive_tab_edge = colors.black,
--         active_tab = {
--             bg_color = colors.lilac,
--             fg_color = colors.black,
--         },
--         inactive_tab = {
--             bg_color = colors.black,
--             fg_color = colors.dark_lilac,
--         },
--         inactive_tab_hover = {
--             bg_color = colors.black,
--             fg_color = colors.lilac,
--         },
--         new_tab = {
--             bg_color = colors.bg,
--             fg_color = colors.lilac,
--         },
--         new_tab_hover = {
--             bg_color = colors.lilac,
--             fg_color = colors.black,
--         },
--     },
-- }

-- Tab bar.
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	font = wezterm.font("Monaspace Neon", { weight = "DemiBold" }),
	active_titlebar_bg = colors.black,
	inactive_titlebar_bg = colors.black,
}

-- config.cell_width = 0.9

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

-- Weights:
-- "Thin"
-- "ExtraLight"
-- "Light"
-- "DemiLight"
-- "Book"
-- "Regular"
-- "Medium"
-- "DemiBold"
-- "Bold"
-- "ExtraBold"
-- "Black"
-- "ExtraBlack"

-- Stretch:
-- "UltraCondensed"
-- "ExtraCondensed"
-- "Condensed"
-- "SemiCondensed"
-- "Normal"
-- "SemiExpanded"
-- "Expanded"
-- "ExtraExpanded"
-- "UltraExpanded".

-- Style:
-- "Normal"
-- "Oblique"
-- "Italic"

local function isNil(param)
	return param == nil
end

local function orDefault(param, fallback)
	if isNil(param) then
		return fallback
	end

	return param
end

local defaultFontProperties = {
	weight = "Regular",
	stretch = "Normal",
	style = "Normal",
	harfbuzz_features = ligature_features,
}

local function font_argon(params)
	local p = orDefault(defaultFontProperties)

	return {
		family = "Monaspace Argon Var",
		weight = p.weight or "Regular",
		stretch = p.stretch or "Normal",
		style = p.style or "Normal",
		harfbuzz_features = ligature_features,
	}
end

config.font = wezterm.font_with_fallback({
	"Berkeley Mono",
	"Mononoki",
	"JetBrains Mono",
	"Fira Code",
	"Source Code Pro",
	"Geist Mono",
	-- "Inconsolata",
	-- "Mononoki",
	-- "Victor Mono",
	-- "Input Mono",
	-- "Maple Mono",
	-- "Geist Mono",
	-- "Iosevka",
	-- "Monaspace Radon",
	-- font_argon(),
	-- "Noto Color Emoji",
	-- 'Operator Mono Lig',
	-- 'Monoid',
	-- 'Monoisome',
	-- 'Menlo',
	-- 'Hack',
	"monospace",
})

config.font_size = 14.85
-- config.font_size = 10.85
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
			family = "Monaspace Radon",
			style = "Italic",
			weight = "Bold",
			harfbuzz_features = ligature_features,
		}),
	},
	--
	-- Half
	--
	{
		intensity = "Half",
		italic = false,
		font = wezterm.font({
			family = "Monaspace Argon Var",
			style = "Normal",
			weight = "ExtraLight",
			harfbuzz_features = ligature_features,
		}),
	},
	--
	-- Half Italic
	--
	{
		intensity = "Half",
		italic = true,
		font = wezterm.font({
			family = "Monaspace Radon",
			style = "Normal",
			weight = "ExtraLight",
			harfbuzz_features = ligature_features,
		}),
	},
}

config.colors = {
	visual_bell = "#202020",
}

--
-- Miscellaneous
--

local misc = {
	adjust_window_size_when_changing_font_size = false,
	check_for_updates = true,
	check_for_updates_interval_seconds = 86400,
	enable_scroll_bar = true,
	enable_kitty_keyboard = true, -- @see https://github.com/wez/wezterm/issues/3731
	enable_csi_u_key_encoding = false, -- @see https://github.com/wez/wezterm/issues/3731
	exit_behavior = "CloseOnCleanExit", -- Use 'Hold' to not close
	hide_tab_bar_if_only_one_tab = true,
	initial_cols = 140,
	initial_rows = 40,
	quote_dropped_files = "Posix",
	switch_to_last_active_tab_when_closing_tab = true,
	use_fancy_tab_bar = true,
	window_decorations = "RESIZE",
	-- window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	-- macos_window_background_blur = 40,
	macos_window_background_blur = 50,
	-- window_background_opacity = 0.92,
	-- window_background_opacity = 1.0,
	window_background_opacity = 0.94,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,

	pane_focus_follows_mouse = true,
	audible_bell = "Disabled",
	visual_bell = {
		fade_out_function = "EaseOut",
		fade_in_duration_ms = 75,
		fade_out_duration_ms = 150,
		target = "CursorColor",
	},
}

for k, v in pairs(misc) do
	config[k] = v
end

-- Make underlines thicker
config.underline_position = -6
config.underline_thickness = "250%"

-- @see https://wezfurlong.org/wezterm/config/lua/wezterm/permute_any_mods.html?h=mouse_bindings
config.mouse_bindings = {
	-- This will disable the default click to open URL behavior
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = "Nop",
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SUPER",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

wezterm.on("format-tab-title", function(tab)
	-- Get the process name.
	local process = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

	-- Current working directory.
	local cwd = tab.active_pane.current_working_dir
	cwd = cwd and string.format("%s ", cwd.file_path:gsub(os.getenv("HOME"), "~")) or ""

	-- Format and return the title.
	return string.format("(%d %s) %s", tab.tab_index + 1, process, cwd)
end)

config.set_environment_variables = {
	-- TODO: this opens without my config
	PATH = os.getenv("HOME") .. "/.local/share/bob/nvim-bin:" .. os.getenv("PATH"),
}

config.keys = {
	-- Disable ctrl - / ctrl = so that we can use them in Vim
	{ key = "-", mods = "CTRL", action = wezterm.action.Nop },
	{ key = "=", mods = "CTRL", action = wezterm.action.Nop },
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action({ SendString = "\x1bf" }),
	},
	-- Select next tab with cmd-opt-left/right arrow
	{
		key = "LeftArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "CMD|OPT",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- Select next pane with cmd-left/right arrow
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action({ ActivatePaneDirection = "Prev" }),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action({ ActivatePaneDirection = "Next" }),
	},
	-- Make cmd + , work to edit settings
	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
			args = { "nvim", wezterm.config_file },
		}),
	},
}

-- @see https://github.com/folke/zen-mode.nvim#wezterm
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
