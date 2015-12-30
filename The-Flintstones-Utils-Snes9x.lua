-----------------------------------------------------------------------------------
--  The Flintstones (U) Utility Script for Snes9x-rr
--  http://tasvideos.org/GameResources/SNES/Flintstones.html
--  
--  Author: BrunoValads 
--  Git repository: https://github.com/brunovalads/the-flintstones-snes
--
--  Based on Amaraticando's Super Mario World script for Snes9x-rr
--  http://github.com/rodamaral/smw-tas/blob/master/Snes9x/smw-snes9x.lua
---------------------------------------------------------------------------

--#############################################################################
-- CONFIG:

local INI_CONFIG_FILENAME = "The Flintstones Utilities Config.ini"  -- relative to the folder of the script

local DEFAULT_OPTIONS = {
    -- Hotkeys
    -- make sure that the hotkeys below don't conflict with previous bindings
    hotkey_decrease_opacity = "numpad-",   -- to decrease the opacity of the text
    hotkey_increase_opacity = "numpad+",  -- to increase the opacity of the text
    
    -- Display
    display_movie_info = true,
    display_misc_info = true,
    display_player_info = true,
	display_player_hitbox = true,
	display_interaction_points = true,
	display_club_hitbox = true,
    display_sprite_info = true,
    display_sprite_hitbox = true, 
    display_extended_sprite_info = true,
    display_extended_sprite_hitbox = true, 
    display_level_info = true,
	display_level_help = true,
    display_counters = true,
	display_stone_trajectory = true,
    display_controller_input = true,
    draw_tiles_with_click = true,
    
    -- Some extra/debug info
    display_debug_info = true,  -- shows useful info while investigating the game, but not very useful while TASing
    display_debug_player_extra = true,
    display_debug_sprite_extra = true,
    display_debug_extended_sprite = true,
    display_debug_controller_data = false,  -- Snes9x: might cause desyncs
    display_miscellaneous_sprite_table = false,
    miscellaneous_sprite_table_number = {[1] = true, [2] = true, [3] = true, [4] = true},
	misc_counter,
	display_mouse_coordinates = true,
	
	-- Passwords and auto pilot cheats
	stage_skip = true,
	invincibility = true,
	auto_pilot = true,
	
	-- Memory edit function
	address = 0x7E0000,
	size = 1,
	value = 0,
	edit_method = "Poke",
	edit_sprite_table = false,
    edit_sprite_table_number = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false, [9] = false,
								[10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = false, [17] = false, [18] = false,
								[19] = false, [20] = false, [21] = false, [22] = false, [23] = false, [24] = false, [25] = false, [26] = false, [27] = false,
							    [28] = false, [29] = false, [30] = false, [31] = false, [32] = false, [33] = false}, -- slots 30~33 are for the reserved sprites
	
    -- Script settings
    max_tiles_drawn = 20,  -- the max number of tiles to be drawn/registered by the script
}

-- Colour settings
local DEFAULT_COLOUR = {
    -- Text
    default_text_opacity = 1.0,
    default_bg_opacity = 0.7,
    text = "#ffffff", -- white
    background = "#000000", -- black
    halo = "#000040", 
	positive = "#00ff00", -- green
    warning = "#ff0000", -- red
    warning_bg = "#000000ff",
    warning2 = "#ff00ff", -- purple
	warning_soft = "#ffa500", -- orange
    weak = "#00a9a9a9",
	weak2 = "#555555", -- gray
    very_weak = "#a0ffffff",
	memory = "#00ffff", -- cyan
    joystick_input = "#ffff00ff",
    joystick_input_bg = "#ffffff30",
    button_text = "#300030ff",
    mainmenu_outline = "#ffffffc0",
    mainmenu_bg = "#000000c0",

	-- Sprites
	sprites = {
        "#80ffff", -- cyan
        "#a0a0ff", -- blue
        "#ff6060", -- red
        "#ff80ff", -- magenta
        "#ffa100", -- orange
        "#ffff80", -- yellow
		"#40ff40"  -- green
	},
	extsprites = {
        "#ff3700", -- orange to red gradient 6
		"#ff5b00", -- orange to red gradient 4
		"#ff8000", -- orange to red gradient 2
		"#ffa500" -- orange to red gradient 0 (orange)
    },
    sprites_bg = "#00ff00",
	
	-- Hitbox and related text
    Fred = "#ff6600",
    Fred_bg = "#ff660055",
    interaction = "#ffffffff",
    interaction_bg = "#00000020",
    interaction_nohitbox = "#000000a0",
    interaction_nohitbox_bg = "#00000070",
	detection_bg = "#40002030",
	
	-- Tiles
	block = "#ffffffff", --"#00008bff",
    blank_tile = "#ffffff70",
    block_bg = "#22cc88a0"
}

-- Font settings
local SNES9X_FONT_HEIGHT = 8
local SNES9X_FONT_WIDTH = 4

-- GD images dumps (encoded)
local GD_IMAGES_DUMPS = {}
GD_IMAGES_DUMPS.stone_animation = {}
GD_IMAGES_DUMPS.stone_animation[1] = {255, 254, 0, 9, 0, 9, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 82, 24, 0, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 0, 0, 0, 0, 82, 24, 0, 0, 198, 99, 33, 0, 198, 99, 33, 0, 239, 148, 99, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 0, 0, 0, 0, 82, 24, 0, 0, 0, 0, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 239, 148, 99, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 82, 24, 0, 0, 0, 0, 0, 0, 148, 57, 24, 0, 82, 24, 0, 0, 239, 148, 99, 0, 239, 148, 99, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 0, 239, 148, 99, 0, 198, 99, 33, 0, 239, 148, 99, 0, 0, 0, 0, 0, 82, 24, 0, 0, 239, 148, 99, 0, 239, 148, 99, 127, 255, 255, 255, 0, 82, 24, 0, 0, 0, 0, 0, 0, 239, 148, 99, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[2] = {255, 254, 0, 8, 0, 8, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 0, 148, 57, 24, 0, 0, 0, 0, 0, 82, 24, 0, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 0, 0, 0, 0, 0, 198, 99, 33, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 127, 255, 255, 255, 0, 148, 57, 24, 0, 148, 57, 24, 0, 239, 148, 99, 0, 198, 99, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 24, 0, 127, 255, 255, 255, 0, 82, 24, 0, 0, 239, 148, 99, 0, 148, 57, 24, 0, 239, 148, 99, 0, 82, 24, 0, 0, 148, 57, 24, 0, 198, 99, 33, 127, 255, 255, 255, 0, 198, 99, 33, 0, 239, 148, 99, 0, 148, 57, 24, 0, 0, 0, 0, 0, 82, 24, 0, 0, 239, 148, 99, 0, 148, 57, 24, 0, 82, 24, 0, 0, 198, 99, 33, 0, 0, 0, 0, 0, 148, 57, 24, 0, 82, 24, 0, 0, 239, 148, 99, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 127, 255, 255, 255, 0, 198, 99, 33, 0, 148, 57, 24, 0, 148, 57, 24, 0, 82, 24, 0, 0, 82, 24, 0, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 239, 148, 99, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[3] = {255, 254, 0, 9, 0, 9, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 0, 148, 57, 24, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 198, 99, 33, 0, 148, 57, 24, 0, 239, 148, 99, 0, 239, 148, 99, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 148, 57, 24, 0, 148, 57, 24, 0, 148, 57, 24, 0, 239, 148, 99, 0, 0, 0, 0, 0, 82, 24, 0, 127, 255, 255, 255, 0, 239, 148, 99, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 0, 148, 57, 24, 0, 82, 24, 0, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 127, 255, 255, 255, 0, 239, 148, 99, 0, 239, 148, 99, 0, 82, 24, 0, 0, 82, 24, 0, 0, 0, 0, 0, 0, 82, 24, 0, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 239, 148, 99, 0, 239, 148, 99, 0, 148, 57, 24, 0, 0, 0, 0, 0, 82, 24, 0, 0, 0, 0, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 239, 148, 99, 0, 198, 99, 33, 0, 148, 57, 24, 0, 82, 24, 0, 0, 0, 0, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[4] = {255, 254, 0, 8, 0, 8, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 239, 148, 99, 0, 239, 148, 99, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 82, 24, 0, 0, 82, 24, 0, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 127, 255, 255, 255, 0, 148, 57, 24, 0, 148, 57, 24, 0, 239, 148, 99, 0, 198, 99, 33, 0, 82, 24, 0, 0, 148, 57, 24, 0, 0, 0, 0, 0, 198, 99, 33, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 0, 239, 148, 99, 0, 239, 148, 99, 0, 239, 148, 99, 0, 82, 24, 0, 0, 148, 57, 24, 127, 255, 255, 255, 0, 198, 99, 33, 0, 148, 57, 24, 0, 148, 57, 24, 0, 239, 148, 99, 0, 148, 57, 24, 0, 239, 148, 99, 0, 82, 24, 0, 127, 255, 255, 255, 0, 82, 24, 0, 0, 0, 0, 0, 0, 82, 24, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 127, 255, 255, 255, 0, 82, 24, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 198, 99, 33, 0, 0, 0, 0, 0, 82, 24, 0, 0, 82, 24, 0, 127, 255, 255, 255, 0, 82, 24, 0, 0, 0, 0, 0, 0, 198, 99, 33, 0, 82, 24, 0, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[5] = {255, 254, 0, 9, 0, 9, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 148, 57, 24, 0, 148, 57, 24, 0, 239, 148, 99, 0, 0, 0, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 0, 148, 57, 24, 0, 239, 148, 99, 0, 239, 148, 99, 0, 239, 148, 99, 0, 239, 148, 99, 0, 239, 148, 99, 127, 255, 255, 255, 0, 82, 24, 0, 0, 0, 0, 0, 0, 148, 57, 24, 0, 148, 57, 24, 0, 82, 24, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 239, 148, 99, 0, 82, 24, 0, 0, 148, 57, 24, 0, 198, 99, 33, 0, 0, 0, 0, 0, 239, 148, 99, 0, 0, 0, 0, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 0, 148, 57, 24, 0, 239, 148, 99, 0, 198, 99, 33, 0, 148, 57, 24, 0, 239, 148, 99, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 0, 82, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 0, 0, 0, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 148, 57, 24, 0, 148, 57, 24, 0, 82, 24, 0, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 0, 82, 24, 0, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[6] = {255, 254, 0, 8, 0, 8, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 148, 57, 24, 0, 82, 24, 0, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 198, 99, 33, 0, 0, 0, 0, 0, 82, 24, 0, 127, 255, 255, 255, 0, 148, 57, 24, 0, 82, 24, 0, 0, 198, 99, 33, 0, 0, 0, 0, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 0, 82, 24, 0, 0, 148, 57, 24, 0, 148, 57, 24, 0, 198, 99, 33, 0, 239, 148, 99, 0, 82, 24, 0, 0, 239, 148, 99, 0, 198, 99, 33, 0, 82, 24, 0, 0, 82, 24, 0, 0, 239, 148, 99, 0, 239, 148, 99, 0, 239, 148, 99, 0, 198, 99, 33, 0, 239, 148, 99, 0, 239, 148, 99, 127, 255, 255, 255, 0, 82, 24, 0, 0, 148, 57, 24, 0, 239, 148, 99, 0, 148, 57, 24, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 127, 255, 255, 255, 0, 198, 99, 33, 0, 239, 148, 99, 0, 198, 99, 33, 0, 148, 57, 24, 0, 82, 24, 0, 0, 82, 24, 0, 0, 239, 148, 99, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 198, 99, 33, 0, 239, 148, 99, 0, 239, 148, 99, 127, 255, 255, 255, 127, 255, 255, 255}
GD_IMAGES_DUMPS.stone_animation[7] = {255, 254, 0, 8, 0, 8, 1, 255, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 82, 24, 0, 0, 82, 24, 0, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 198, 99, 33, 0, 148, 57, 24, 0, 148, 57, 24, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 148, 57, 24, 0, 239, 148, 99, 0, 239, 148, 99, 0, 0, 0, 0, 0, 239, 148, 99, 0, 239, 148, 99, 0, 82, 24, 0, 127, 255, 255, 255, 0, 239, 148, 99, 0, 148, 57, 24, 0, 148, 57, 24, 0, 0, 0, 0, 0, 198, 99, 33, 0, 82, 24, 0, 0, 0, 0, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 0, 0, 0, 0, 198, 99, 33, 0, 148, 57, 24, 0, 82, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 198, 99, 33, 0, 198, 99, 33, 0, 82, 24, 0, 0, 198, 99, 33, 0, 198, 99, 33, 0, 239, 148, 99, 0, 82, 24, 0, 127, 255, 255, 255, 0, 198, 99, 33, 0, 239, 148, 99, 0, 82, 24, 0, 0, 198, 99, 33, 0, 239, 148, 99, 0, 198, 99, 33, 0, 198, 99, 33, 127, 255, 255, 255, 127, 255, 255, 255, 127, 255, 255, 255, 0, 239, 148, 99, 0, 82, 24, 0, 0, 239, 148, 99, 0, 198, 99, 33, 0, 82, 24, 0, 127, 255, 255, 255}

-- Symbols
local LEFT_ARROW = "<-"
local RIGHT_ARROW = "->"

-- Others
local Border_right, Border_left, Border_top, Border_bottom = 0, 0, 0, 0
local Buffer_width, Buffer_height, Buffer_middle_x, Buffer_middle_y = 256, 224, 128, 112
local Screen_width, Screen_height, AR_x, AR_y = 256, 224, 1, 1
local Y_CAMERA_OFF = 1  -- small adjustment for screen coordinates <-> object position conversion

-- Input key names
local INPUT_KEYNAMES = { -- Snes9x
    xmouse=0, ymouse=0, leftclick=false, rightclick=false, middleclick=false,
    shift=false, control=false, alt=false, capslock=false, numlock=false, scrolllock=false,
    ["false"]=false, ["1"]=false, ["2"]=false, ["3"]=false, ["4"]=false, ["5"]=false, ["6"]=false, ["7"]=false, ["8"]=false,["9"]=false,
    A=false, B=false, C=false, D=false, E=false, F=false, G=false, H=false, I=false, J=false, K=false, L=false, M=false, N=false,
    O=false, P=false, Q=false, R=false, S=false, T=false, U=false, V=false, W=false, X=false, Y=false, Z=false,
    F1=false, F2=false, F3=false, F4=false, F5=false, F6=false, F7=false, F8=false, F9=false, F1false=false, F11=false, F12=false,
    F13=false, F14=false, F15=false, F16=false, F17=false, F18=false, F19=false, F2false=false, F21=false, F22=false, F23=false, F24=false,
    backspace=false, tab=false, enter=false, pause=false, escape=false, space=false,
    pageup=false, pagedown=false, ["end"]=false, home=false, insert=false, delete=false,
    left=false, up=false, right=false, down=false,
    numpadfalse=false, numpad1=false, numpad2=false, numpad3=false, numpad4=false, numpad5=false, numpad6=false, numpad7=false, numpad8=false, numpad9=false,
    ["numpad*"]=false, ["numpad+"]=false, ["numpad-"]=false, ["numpad."]=false, ["numpad/"]=false,
    tilde=false, plus=false, minus=false, leftbracket=false, rightbracket=false,
    semicolon=false, quote=false, comma=false, period=false, slash=false, backslash=false
}

-- Keyboard/mouse input tables (from gocha's)
local dev_press, dev_down, dev_up, dev_prev = input.get(), {}, {}, {}
local dev_presstime = {
    xmouse=0, ymouse=0, leftclick=0, rightclick=0, middleclick=0,
    shift=0, control=0, alt=0, capslock=0, numlock=0, scrolllock=0,
    ["0"]=0, ["1"]=0, ["2"]=0, ["3"]=0, ["4"]=0, ["5"]=0, ["6"]=0, ["7"]=0, ["8"]=0, ["9"]=0,
    A=0, B=0, C=0, D=0, E=0, F=0, G=0, H=0, I=0, J=0, K=0, L=0, M=0, N=0, O=0, P=0, Q=0, R=0, S=0, T=0, U=0, V=0, W=0, X=0, Y=0, Z=0,
    F1=0, F2=0, F3=0, F4=0, F5=0, F6=0, F7=0, F8=0, F9=0, F10=0, F11=0, F12=0,
    F13=0, F14=0, F15=0, F16=0, F17=0, F18=0, F19=0, F20=0, F21=0, F22=0, F23=0, F24=0,
    backspace=0, tab=0, enter=0, pause=0, escape=0, space=0,
    pageup=0, pagedown=0, ["end"]=0, home=0, insert=0, delete=0,
    left=0, up=0, right=0, down=0,
    numpad0=0, numpad1=0, numpad2=0, numpad3=0, numpad4=0, numpad5=0, numpad6=0, numpad7=0, numpad8=0, numpad9=0,
    ["numpad*"]=0, ["numpad+"]=0, ["numpad-"]=0, ["numpad."]=0, ["numpad/"]=0,
    tilde=0, plus=0, minus=0, leftbracket=0, rightbracket=0,
    semicolon=0, quote=0, comma=0, period=0, slash=0, backslash=0
}

-- END OF CONFIG < < < < < < <
--#############################################################################
-- INITIAL STATEMENTS:


print("Starting script")

-- Load environment
local gui, input, joypad, emu, movie, memory = gui, input, joypad, emu, movie, memory
local unpack = unpack or table.unpack
local string, math, table, next, ipairs, pairs, io, os, type = string, math, table, next, ipairs, pairs, io, os, type
local bit = require"bit"

-- Script tries to verify whether the emulator is indeed Snes9x-rr
if snes9x == nil then
    error("This script works with Snes9x-rr emulator.")
end

-- TEST: INI library for handling an ini configuration file
function file_exists(name)
   local f = io.open(name, "r")
   if f ~= nil then io.close(f) return true else return false end
end

function copytable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copytable(orig_key)] = copytable(orig_value) -- possible stack overflow
        end
        setmetatable(copy, copytable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function mergetable(source, t2)
    for key, value in pairs(t2) do
    	if type(value) == "table" then
    		if type(source[key] or false) == "table" then
    			mergetable(source[key] or {}, t2[key] or {}) -- possible stack overflow
    		else
    			source[key] = value
    		end
    	else
    		source[key] = value
    	end
    end
    return source
end

-- Creates a set from a list
local function make_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

local INI = {}

function INI.arg_to_string(value)
    local str
    if type(value) == "string" then
        str = "\"" .. value .. "\""
    elseif type(value) == "number" or type(value) == "boolean" or value == nil then
        str = tostring(value)
    elseif type(value) == "table" then
        local tmp = {"{"}  -- only arrays
        for a, b in ipairs(value) do
            table.insert(tmp, ("%s%s"):format(INI.arg_to_string(b), a ~= #value and ", " or "")) -- possible stack overflow
        end
        table.insert(tmp, "}")
        str = table.concat(tmp)
    else
        str = "#BAD_VALUE"
    end
    
    return str
end

-- creates the string for ini
function INI.data_to_string(data)
	local sections = {}
    
	for section, prop in pairs(data) do
        local properties = {}
		
        for key, value in pairs(prop) do
            table.insert(properties, ("%s = %s\n"):format(key, INI.arg_to_string(value)))  -- properties
		end
        
        table.sort(properties)
        table.insert(sections, ("[%s]\n"):format(section) .. table.concat(properties) .. "\n")
	end
    
    table.sort(sections)
    return table.concat(sections)
end

function INI.string_to_data(value)
    local data
    
    if tonumber(value) then
        data = tonumber(value)
    elseif value == "true" then
        data = true
    elseif value == "false" then
        data = false
    elseif value == "nil" then
        data = nil
    else
        local quote1, text, quote2 = value:match("(['\"{])(.+)(['\"}])")  -- value is surrounded by "", '' or {}?
        if quote1 and quote2 and text then
            if (quote1 == '"' or quote1 == "'") and quote1 == quote2 then
                data = text
            elseif quote1 == "{" and quote2 == "}" then
                local tmp = {} -- test
                for words in text:gmatch("[^,%s]+") do
                    tmp[#tmp + 1] = INI.string_to_data(words) -- possible stack overflow
                end
                
                data = tmp
            else
                data = value
            end
        else
            data = value
        end
    end
    
    return data
end

function INI.load(filename)
    local file = io.open(filename, "r")
    if not file then return false end
    
    local data, section = {}, nil
    
	for line in file:lines() do
        local new_section = line:match("^%[([^%[%]]+)%]$")
		
        if new_section then
            section = INI.string_to_data(new_section) and INI.string_to_data(new_section) or new_section
            if data[section] then print("Duplicated section") end
			data[section] = data[section] or {}
        else
            
            local prop, value = line:match("^([%w_%-%.]+)%s*=%s*(.+)%s*$")  -- prop = value
            
            if prop and value then
                value = INI.string_to_data(value)
                prop = INI.string_to_data(prop) and INI.string_to_data(prop) or prop
                
                if data[section] == nil then print(prop, value) ; error("Property outside section") end
                data[section][prop] = value
            else
                local ignore = line:match("^;") or line == ""
                if not ignore then
                    print("BAD LINE:", line, prop, value)
                end
            end
            
        end
        
	end
    
	file:close()
    return data
end

function INI.retrieve(filename, data)
    if type(data) ~= "table" then error"data must be a table" end
    local previous_data
    
    -- Verifies if file already exists
    if file_exists(filename) then
        ini_data = INI.load(filename)
    else return data
    end
    
    -- Adds previous values to the new ini
    local union_data = mergetable(data, ini_data)
    return union_data
end

function INI.overwrite(filename, data)
    local file, err = assert(io.open(filename, "w"), "Error loading file :" .. filename)
    if not file then print(err) ; return end
    
	file:write(INI.data_to_string(data))
	file:close()
end

function INI.save(filename, data)
    if type(data) ~= "table" then error"data must be a table" end
    
    local tmp, previous_data
    if file_exists(filename) then
        previous_data = INI.load(filename)
        tmp = mergetable(previous_data, data)
    else
        tmp = data
    end
    
    INI.overwrite(filename, tmp)
end

local OPTIONS = file_exists(INI_CONFIG_FILENAME) and INI.retrieve(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = DEFAULT_OPTIONS}).OPTIONS or DEFAULT_OPTIONS
local COLOUR = file_exists(INI_CONFIG_FILENAME) and INI.retrieve(INI_CONFIG_FILENAME, {["SNES9X COLOURS"] = DEFAULT_COLOUR}).COLOURS or DEFAULT_COLOUR
INI.save(INI_CONFIG_FILENAME, {["SNES9X COLOURS"] = COLOUR})  -- Snes9x doesn't need to convert colour string to number
INI.save(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = OPTIONS})

function INI.save_options()
    INI.save(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = OPTIONS})
end


--######################## -- end of test

-- Text/Background_max_opacity is only changed by the player using the hotkeys
-- Text/Bg_opacity must be used locally inside the functions
local Text_max_opacity = COLOUR.default_text_opacity
local Background_max_opacity = COLOUR.default_bg_opacity
local Text_opacity = 1
local Bg_opacity = 1

local fmt = string.format
local floor = math.floor

-- unsigned to signed (based in <bits> bits)
local function signed(num, bits)
    local maxval = 2^(bits - 1)
    if num < maxval then return num else return num - 2*maxval end
end

-- Compatibility of the memory read/write functions
local u8 =  memory.readbyte
local s8 =  memory.readbytesigned
local w8 =  memory.writebyte
local u16 = memory.readword
local s16 = memory.readwordsigned
local w16 = memory.writeword
local u24 = function(address, value) return 256*u16(address + 1) + u8(address) end
local s24 = function(address, value) return signed(256*u16(address + 1) + u8(address), 24) end
local w24 = function(address, value) w16(address + 1, floor(value/256)) ; w8(address, value%256) end

-- Images (for gd library)
local IMAGES = {}
IMAGES.stone_animation = {}
for k = 1, 7 do
	IMAGES.stone_animation[k] = string.char(unpack(GD_IMAGES_DUMPS.stone_animation[k]))
end

-- Hotkeys availability
if INPUT_KEYNAMES[OPTIONS.hotkey_increase_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to increase opacity.", OPTIONS.hotkey_increase_opacity))
else print(string.format("Hotkey '%s' set to increase opacity.", OPTIONS.hotkey_increase_opacity))
end
if INPUT_KEYNAMES[OPTIONS.hotkey_decrease_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
else print(string.format("Hotkey '%s' set to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
end


--#############################################################################
-- GAME AND SNES SPECIFIC MACROS:


local NTSC_FRAMERATE = 60.0

FLINT = {
	game_mode_level = 0xB23B,
    sprite_max = 29,
	extended_sprite_max = 4
}

WRAM = {
    -- General
    game_mode = 0x0040, -- 2 bytes
	level_index = 0x1D5B,
	timer = 0x1D8D, -- 2 bytes
	is_paused = 0x0636,
	score = 0x1D75, -- 2 bytes
    
	-- Camera
	camera_x = 0x001C, -- 2 bytes
	camera_y = 0x001E, -- 2 bytes
	
    -- Fred
	hitbox_corner1_x = 0x00D7, -- 2 bytes
	hitbox_corner1_y = 0x00DB, -- 2 bytes
	hitbox_corner2_x = 0x00D9, -- 2 bytes
	hitbox_corner2_y = 0x00DD, -- 2 bytes
	sprite_platforming_left_x = 0x00DF, -- 2 bytes
	sprite_platforming_left_y = 0x00E3, -- 2 bytes
	sprite_platforming_right_x = 0x00E1, -- 2 bytes
	sprite_platforming_right_y = 0x00E5, -- 2 bytes		
	club_hitbox_corner1_x = 0x00E7, -- 2 bytes
	club_hitbox_corner1_y = 0x00EB, -- 2 bytes
	club_hitbox_corner2_x = 0x00E9, -- 2 bytes
	club_hitbox_corner2_y = 0x00ED, -- 2 bytes
	fred_loaded = 0x0944,
    x = 0x0988, -- 2 bytes
	y = 0x09CC, -- 2 bytes
	x_sub = 0x0A11,
	y_sub = 0x0A55,
	direction = 0x0CB9,
	x_speed = 0x0D85,
	x_subspeed = 0x0D84,
	y_speed = 0x0DC9,
	y_subspeed = 0x0DC8,
	on_ground = 0x0E94,
	last_valid_x = 0x0FF0, -- 2 bytes
	last_valid_y = 0x0FF2, -- 2 bytes
	status = 0x0FF6,
	is_smashing = 0x1000,
	invincibility_timer = 0x1D51,
	lives = 0x1D65,
	health = 0x1D69,
	stones = 0x1D6D,
	bowling_balls = 0x1D71,
	throw_power = 0x1DD5, -- 2 bytes (but only the first is used)
	idle_timer = 0x1DD7, -- 2 bytes
	
    -- Sprites
    sprite_type = 0x0946,
	sprite_x = 0x098A, -- 2 bytes
	sprite_y = 0x09CE, -- 2 bytes
	sprite_x_sub = 0x0A13,
	sprite_y_sub = 0x0A57,
	sprite_x_speed = 0x0D87,
	sprite_x_subspeed = 0x0D86,
	sprite_y_speed = 0x0DCB,
	sprite_y_subspeed = 0x0DCA,    
	sprite_miscellaneous1 = 0x0ADE, -- 2 bytes
	sprite_miscellaneous2 = 0x0B22, -- 2 bytes
	sprite_miscellaneous3 = 0x0B66, -- 2 bytes
	sprite_miscellaneous4 = 0x0BAA, -- 2 bytes
	caveman_boss_animation = 0x0AC4,
	caveman_boss_misc_5_high = 0x0BD5,
	
    -- Extended sprites
    extsprite_type = 0x0980,
	extsprite_x = 0x09C4, -- 2 bytes
	extsprite_y = 0x0A08, -- 2 bytes
	extsprite_x_sub = 0x0A4D,
	extsprite_y_sub = 0x0A91,
	extsprite_x_speed = 0x0DC1,
	extsprite_x_subspeed = 0x0DC0,
	extsprite_y_speed = 0x0E05,
	extsprite_y_subspeed = 0x0E04,
	extsprite_miscellaneous1 = 0x0B18, -- 2 bytes
	extsprite_miscellaneous2 = 0x0B5C, -- 2 bytes
	extsprite_miscellaneous3 = 0x0BA0, -- 2 bytes
	extsprite_miscellaneous4 = 0x0BE4, -- 2 bytes
	
    -- Passwords
	stage_skip = 0x0622,
	invincibility = 0x0624,
	
	-- Others
	boss_hp = 0x1ED6,
	lava_wave_x = 0x1DEB,
	lava_wave_y = 0x1DED,
	lava_flood_y_static = 0x1E0E,
	lava_flood_y_oscillating = 0x1E10
	
}
for name, address in pairs(WRAM) do
    address = address + 0x7e0000  -- Snes9x
end
local WRAM = WRAM

-- Creates a set from a list
local function make_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

--#############################################################################
-- SCRIPT UTILITIES:


-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}
local User_input = INPUT_KEYNAMES -- Snes9x
local Tiletable = {}
local Update_screen = true
local Is_lagged = nil
local Options_menu = {show_menu = false, current_tab = "Show/hide options"}
local Filter_opacity, Filter_color = 0, "#000000ff"  -- Snes9x specifc / unlisted color
local Show_player_point_position = false
local Sprites_info = {}  -- keeps track of useful sprite info that might be used outside the main sprite function
local Memory = {} -- family of memory edit functions and variables

-- Initialization of some tables
for i = 0, 2*FLINT.sprite_max - 1 do
    Sprites_info[i] = {}
end


-- Sum of the digits of a integer
local function sum_digits(number)
    local sum = 0
    while number > 0 do
        sum = sum + number%10
        number = floor(number*0.1)
    end
    
    return sum
end


-- Returns the exact chosen digit of a number from the left to the right, in a given base
-- E.g.: read_digit(654321, 2, 10) -> 5; read_digit(0x4B7A, 3, 16) -> 7
local function read_digit(number, digit, base)
    --assert(type(number) == "number" and number >= 0 and number%1 == 0, "Enter an integer number > 0")
    --assert(type(digit) == "number" and digit > 0 and digit%1 == 0, "Enter an integer digit > 0")
    --assert(type(base) == "number" and base > 1 and base%1 == 0, "Enter an integer base > 1")
    
    local copy = number
    local digits_total = 0
    while copy >= 1 do
        copy = math.floor(copy/base)
        digits_total = digits_total + 1
    end
    
    if digit > digits_total then return false end
    
    local result = math.floor(number/base^(digits_total - digit))
    return result%base
end


-- Transform the binary representation of base into a string
-- For instance, if each bit of a number represents a char of base, then this function verifies what chars are on
local function decode_bits(data, base)
    local result = {}
    local i = 1
    local size = base:len()
    
    for ch in base:gmatch(".") do
        if bit.test(data, size-i) then
            result[i] = ch
        else
            result[i] = " "
        end
        i = i + 1
    end
    
    return table.concat(result)
end


function bit.test(value, bitnum)  -- Snes9x
    return bit.rshift(value, bitnum)%2 == 1
end


local function mouse_onregion(x1, y1, x2, y2)
    -- Reads external mouse coordinates
    local mouse_x = User_input.xmouse
    local mouse_y = User_input.ymouse
    
    -- From top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    if mouse_x >= x1 and mouse_x <= x2 and  mouse_y >= y1 and mouse_y <= y2 then
        return true
    else
        return false
    end
end


-- Register a function to be executed on key press or release
-- execution happens in the main loop
local Keys = {}
Keys.press = {}
Keys.release = {}
Keys.down, Keys.up, Keys.pressed, Keys.released = {}, {}, {}, {}
function Keys.registerkeypress(key, fn)
    Keys.press[key] = fn
end
function Keys.registerkeyrelease(key, fn)
    Keys.release[key] = fn
end


-- A cross sign with pos and size
gui.crosshair = gui.crosshair or function(x, y, size, color)
    gui.line(x - size, y, x + size, y, color)
    gui.line(x, y-size, x, y+size, color)
end


local Movie_active, Readonly, Framecount, Lagcount, Rerecords
local Lastframe_emulated, Starting_subframe_last_frame, Size_last_frame, Final_subframe_last_frame
local Nextframe, Starting_subframe_next_frame, Starting_subframe_next_frame, Final_subframe_next_frame
local function snes9x_status()
    Movie_active = movie.active()  -- Snes9x
    Readonly = movie.playing()  -- Snes9x
    Framecount = movie.length()
    Lagcount = emu.lagcount() -- Snes9x
    Rerecords = movie.rerecordcount()
    
    -- Last frame info
    Lastframe_emulated = emu.framecount()
    
    -- Next frame info (only relevant in readonly mode)
    Nextframe = Lastframe_emulated + 1
    
end


-- draw a pixel given (x,y) with SNES' pixel sizes
local draw_pixel = gui.pixel


-- draws a line given (x,y) and (x',y') with given scale and SNES' pixel thickness (whose scale is 2) -- EDIT
local function draw_line(x1, y1, x2, y2, scale, color)
    -- Draw from top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    x1, y1, x2, y2 = scale*x1, scale*y1, scale*x2, scale*y2
    gui.line(x1, y1, x2, y2, color)
end


-- draw an arrow given (x,y) and (x',y')
local function draw_arrow(x1, y1, x2, y2, color, head)
	
	local angle = math.atan((y2-y1)/(x2-x1)) -- in radians
	
	-- Arrow head
	local head_size = head or 10
	local angle1, angle2 = angle + math.pi/4, angle - math.pi/4 --0.785398163398, angle - 0.785398163398 -- 45° in radians
	local delta_x1, delta_y1 = floor(head_size*math.cos(angle1)), floor(head_size*math.sin(angle1))
	local delta_x2, delta_y2 = floor(head_size*math.cos(angle2)), floor(head_size*math.sin(angle2))
	local head1_x1, head1_y1 = x2, y2 
	local head1_x2, head1_y2 
	local head2_x1, head2_y1 = x2, y2
	local head2_x2, head2_y2
	
	if x1 < x2 then -- 1st and 4th quadrant
		head1_x2, head1_y2 = head1_x1 - delta_x1, head1_y1 - delta_y1
		head2_x2, head2_y2 = head2_x1 - delta_x2, head2_y1 - delta_y2
	elseif x1 == x2 then -- vertical arrow
		head1_x2, head1_y2 = head1_x1 - delta_x1, head1_y1 - delta_y1
		head2_x2, head2_y2 = head2_x1 - delta_x2, head2_y1 - delta_y2
	else
		head1_x2, head1_y2 = head1_x1 + delta_x1, head1_y1 + delta_y1
		head2_x2, head2_y2 = head2_x1 + delta_x2, head2_y1 + delta_y2
	end
	
	-- Draw
	gui.line(x1, y1, x2, y2, color)
	gui.line(head1_x1, head1_y1, head1_x2, head1_y2, color)
	gui.line(head2_x1, head2_y1, head2_x2, head2_y2, color)
end


-- draws a box given (x,y) and (x',y') with SNES' pixel sizes
local draw_box = function(x1, y1, x2, y2, line, fill)
    gui.box(x1, y1, x2, y2, fill, line)
end


-- draws a rectangle given (x,y) and dimensions, with SNES' pixel sizes
local draw_rectangle = function(x, y, w, h, line, fill)
    gui.box(x, y, x + w, y + h, fill, line)
end


-- Takes a position and dimensions of a rectangle and returns a new position if this rectangle has points outside the screen
local function put_on_screen(x, y, width, height)
    local x_screen, y_screen
    width = width or 0
    height = height or 0
    
    if x < - Border_left then
        x_screen = - Border_left
    elseif x > Buffer_width + Border_right - width then
        x_screen = Buffer_width + Border_right - width
    else
        x_screen = x
    end
    
    if y < - Border_top then
        y_screen = - Border_top
    elseif y > Buffer_height + Border_bottom - height then
        y_screen = Buffer_height + Border_bottom - height
    else
        y_screen = y
    end
    
    return x_screen, y_screen
end


-- returns the (x, y) position to start the text and its length:
-- number, number, number text_position(x, y, text, font_width, font_height[[[[, always_on_client], always_on_game], ref_x], ref_y])
-- x, y: the coordinates that the refereed point of the text must have
-- text: a string, don't make it bigger than the buffer area width and don't include escape characters
-- font_width, font_height: the sizes of the font
-- always_on_client, always_on_game: boolean
-- ref_x and ref_y: refer to the relative point of the text that must occupy the origin (x,y), from 0% to 100%
--                  for instance, if you want to display the middle of the text in (x, y), then use 0.5, 0.5
local function text_position(x, y, text, font_width, font_height, always_on_client, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local border_left     = 0
    local border_right    = 0
    local border_top      = 0
    local border_bottom   = 0
    local buffer_width    = 256
    local buffer_height   = 224
    
    -- text processing
    local text_length = text and string.len(text)*font_width or font_width  -- considering another objects, like bitmaps
    
    -- actual position, relative to game area origin
    x = (not ref_x and x) or (ref_x == 0 and x) or x - floor(text_length*ref_x)
    y = (not ref_y and y) or (ref_y == 0 and y) or y - floor(font_height*ref_y)
    
    -- adjustment needed if text is supposed to be on screen area
    local x_end = x + text_length
    local y_end = y + font_height
    
    if always_on_game then
        if x < 0 then x = 0 end
        if y < 0 then y = 0 end
        
        if x_end > buffer_width  then x = buffer_width  - text_length end
        if y_end > buffer_height then y = buffer_height - font_height end
        
    elseif always_on_client then
        if x < -border_left then x = -border_left end
        if y < -border_top  then y = -border_top  end
        
        if x_end > buffer_width  + border_right  then x = buffer_width  + border_right  - text_length end
        if y_end > buffer_height + border_bottom then y = buffer_height + border_bottom - font_height end
    end
    
    return x, y, text_length
end


-- Complex function for drawing, that uses text_position
local function draw_text(x, y, text, ...)
    -- Reads external variables
    local font_name = Font or false
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    local bg_default_color = font_name and COLOUR.outline or COLOUR.background
    local text_color, bg_color, always_on_client, always_on_game, ref_x, ref_y
    local arg1, arg2, arg3, arg4, arg5, arg6 = ...
    
    if not arg1 or arg1 == true then
        
        text_color = COLOUR.text
        bg_color = bg_default_color
        always_on_client, always_on_game, ref_x, ref_y = arg1, arg2, arg3, arg4
        
    elseif not arg2 or arg2 == true then
        
        text_color = arg1
        bg_color = bg_default_color
        always_on_client, always_on_game, ref_x, ref_y = arg2, arg3, arg4, arg5
        
    else
        
        text_color, bg_color = arg1, arg2
        always_on_client, always_on_game, ref_x, ref_y = arg3, arg4, arg5, arg6
        
    end
    
    local x_pos, y_pos, length = text_position(x, y, text, font_width, font_height,
                                    always_on_client, always_on_game, ref_x, ref_y)
    ;
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, bg_color)
    gui.opacity(1.0) -- Snes9x
    
    return x_pos + length, y_pos + font_height, length
end


local function alert_text(x, y, text, text_color, bg_color, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    
    local x_pos, y_pos, text_length = text_position(x, y, text, font_width, font_height, false, always_on_game, ref_x, ref_y)
    
    gui.opacity(Background_max_opacity * Bg_opacity)
    draw_rectangle(x_pos, y_pos, text_length - 1, font_height - 1, bg_color, bg_color)  -- Snes9x
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, 0)
    gui.opacity(1.0)
end


local function draw_over_text(x, y, value, base, color_base, color_value, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    value = decode_bits(value, base)
    local x_end, y_end, length = draw_text(x, y, base,  color_base, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_end - length, y_end - SNES9X_FONT_HEIGHT, value, color_value or COLOUR.text)
    gui.opacity(1.0)
    
    return x_end, y_end, length
end


-- Returns frames-time conversion
local function frame_time(frame)
    if not NTSC_FRAMERATE then error("NTSC_FRAMERATE undefined."); return end
    
    local total_seconds = frame/NTSC_FRAMERATE
    local hours = floor(total_seconds/3600)
    local tmp = total_seconds - 3600*hours
    local minutes = floor(tmp/60)
    tmp = tmp - 60*minutes
    local seconds = floor(tmp)
    
    local miliseconds = 1000* (total_seconds%1)
    if hours == 0 then hours = "" else hours = string.format("%d:", hours) end
    local str = string.format("%s%.2d:%.2d.%03.0f", hours, minutes, seconds, miliseconds)
    return str
end


-- Background opacity functions
local function increase_opacity()
    if Text_max_opacity <= 0.9 then Text_max_opacity = Text_max_opacity + 0.1
    else
        if Background_max_opacity <= 0.9 then Background_max_opacity = Background_max_opacity + 0.1 end
    end
end


local function decrease_opacity()
    if  Background_max_opacity >= 0.1 then Background_max_opacity = Background_max_opacity - 0.1
    else
        if Text_max_opacity >= 0.1 then Text_max_opacity = Text_max_opacity - 0.1 end
    end
end


-- displays a button everytime in (x,y)
-- object can be a text or a dbitmap
-- if user clicks onto it, fn is executed once
local Script_buttons = {}
local function create_button(x, y, object, fn, extra_options)
    local always_on_client, always_on_game, ref_x, ref_y, button_pressed
    if extra_options then
        always_on_client, always_on_game, ref_x, ref_y, button_pressed = extra_options.always_on_client, extra_options.always_on_game,
                                                                extra_options.ref_x, extra_options.ref_y, extra_options.button_pressed
    end
    
    local width, height
    local object_type = type(object)
    
    if object_type == "string" then
        width, height = SNES9X_FONT_WIDTH, SNES9X_FONT_HEIGHT
        x, y, width = text_position(x, y, object, width, height, always_on_client, always_on_game, ref_x, ref_y)
    elseif object_type == "boolean" then
        width, height = SNES9X_FONT_WIDTH, SNES9X_FONT_HEIGHT
        x, y = text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
    else error"Type of buttton not supported yet"
    end
    
    -- draw the button
    if button_pressed then
        draw_rectangle(x, y, width, height, "white", "#d8d8d8ff")  -- unlisted colours
    else
        draw_rectangle(x, y, width, height, "#606060ff", "#b0b0b0ff")
    end
    gui.line(x, y, x + width, y, button_pressed and "#606060ff" or "white")
    gui.line(x, y, x, y + height, button_pressed and "#606060ff" or "white")
    
    if object_type == "string" then
        gui.text(x + 1, y + 1, object, COLOUR.button_text, 0)
    elseif object_type == "boolean" then
        draw_rectangle(x + 1, y + 1, width - 2, height - 2, "#00ff0080", "#00ff00c0")
    end
		
    -- updates the table of buttons
    table.insert(Script_buttons, {x = x, y = y, width = width, height = height, object = object, action = fn})
end


function Options_menu.print_help() --TODO
    print("\n")
    print(" - - - TIPS - - - ")
    print("MOUSE:")
    print("Use the left click to draw blocks")
    print("Use the right click to toogle the hitbox mode of Mario and sprites.")
    print("\n")
    
    print("CHEATS(better turn off while recording a movie):")
    print("L+R+up: stop gravity for Fred fly / L+R+down to cancel")
    --print("Use the mouse to drag and drop sprites")
    
    print("\n")
    print("OTHERS:")
    print(fmt("Press \"%s\" for more and \"%s\" for less opacity.", OPTIONS.hotkey_increase_opacity, OPTIONS.hotkey_decrease_opacity))
    print("It's better to play without the mouse over the game window.")
    print(" - - - end of tips - - - ")
end

local poked = false
local apply = false
function Options_menu.display() -- TODO
    if not Options_menu.show_menu then return end
    
    -- Pauses emulator and draws the background
    Text_opacity = 1.0
    draw_rectangle(0, 0, Buffer_width, Buffer_height, COLOUR.mainmenu_outline, COLOUR.mainmenu_bg)
    
    -- Font stuff
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT + 4
    local x_pos, y_pos = 4, 4
    local tmp, tmp_str
    
    -- Exit menu button
    gui.box(0, 0, Buffer_width, delta_y, "#ffffff60", "#ffffff60") -- tab's shadow / unlisted color
    create_button(Buffer_width, 0, " X ", function() Options_menu.show_menu = false end, {always_on_client = true, always_on_game = true})
    
    -- Tabs
    create_button(x_pos, y_pos, "Show/hide", function() Options_menu.current_tab = "Show/hide options" end,
    {button_pressed = Options_menu.current_tab == "Show/hide options"})
    x_pos = x_pos + 9*delta_x + 2
    create_button(x_pos, y_pos, "Settings", function() Options_menu.current_tab = "Misc options" end,
    {button_pressed = Options_menu.current_tab == "Misc options"})
    x_pos = x_pos + 8*delta_x + 2
    create_button(x_pos, y_pos, "Cheats", function() Options_menu.current_tab = "Cheats" end,
    {button_pressed = Options_menu.current_tab == "Cheats"})
    x_pos = x_pos + 6*delta_x + 2
    create_button(x_pos, y_pos, "Debug info", function() Options_menu.current_tab = "Debug info" end,
    {button_pressed = Options_menu.current_tab == "Debug info"})
    x_pos = x_pos + 10*delta_x + 2
    create_button(x_pos, y_pos, "Misc tables", function() Options_menu.current_tab = "Sprite miscellaneous tables" end,
    {button_pressed = Options_menu.current_tab == "Sprite miscellaneous tables"})
    x_pos = x_pos + 11*delta_x + 2
    create_button(x_pos, y_pos, "Memory edit", function() Options_menu.current_tab = "Memory edit" end,
    {button_pressed = Options_menu.current_tab == "Memory edit"})
    
    x_pos, y_pos = 4, y_pos + delta_y + 4
    if Options_menu.current_tab == "Show/hide options" then
		local x_temp = 0
		
		-- Player
		tmp_str = "Player:"
        gui.text(x_pos, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 4
		
        tmp = OPTIONS.display_player_info and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_player_info = not OPTIONS.display_player_info end)
		tmp_str = "Info"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
        tmp = OPTIONS.display_player_hitbox and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_player_hitbox = not OPTIONS.display_player_hitbox end)
		tmp_str = "Hitbox"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
        tmp = OPTIONS.display_interaction_points and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_interaction_points = not OPTIONS.display_interaction_points end)
		tmp_str = "Interaction points"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
        tmp = OPTIONS.display_club_hitbox and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_club_hitbox = not OPTIONS.display_club_hitbox end)
		tmp_str = "Club hitbox"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = 0 + 4*string.len("Player:") + 4
        y_pos = y_pos + delta_y
		
        tmp = OPTIONS.display_stone_trajectory and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_stone_trajectory = not OPTIONS.display_stone_trajectory end)
		tmp_str = "Stone trajectory"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
        y_pos = y_pos + delta_y + 4
        
		-- Sprites
		x_temp = 0
		tmp_str = "Sprites:"
        gui.text(x_pos, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 4
        tmp = OPTIONS.display_sprite_info and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_sprite_info = not OPTIONS.display_sprite_info end)
		tmp_str = "Info"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 12
        tmp = OPTIONS.display_sprite_hitbox and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_sprite_hitbox = not OPTIONS.display_sprite_hitbox end)
		tmp_str = "Hitboxes"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
        y_pos = y_pos + delta_y + 4
        
		-- Extended sprites
		x_temp = 0
		tmp_str = "Extended Sprites:"
        gui.text(x_pos, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 4
        tmp = OPTIONS.display_extended_sprite_info and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_extended_sprite_info = not OPTIONS.display_extended_sprite_info end)
		tmp_str = "Info"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 12
        tmp = OPTIONS.display_extended_sprite_hitbox and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_extended_sprite_hitbox = not OPTIONS.display_extended_sprite_hitbox end)
		tmp_str = "Hitboxes"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
        y_pos = y_pos + delta_y + 4
        
		-- Level
		x_temp = 0
		tmp_str = "Level:"
        gui.text(x_pos, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 4
        tmp = OPTIONS.display_level_info and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_level_info = not OPTIONS.display_level_info end)
		tmp_str = "Info"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		
		x_temp = x_temp + 4*string.len(tmp_str) + 12
        tmp = OPTIONS.display_level_help and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.display_level_help = not OPTIONS.display_level_help end)
		tmp_str = "Extra help"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
        y_pos = y_pos + delta_y + 4
        
		-- Rest
        tmp = OPTIONS.display_debug_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_info = not OPTIONS.display_debug_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Some Debug Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_misc_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_misc_info = not OPTIONS.display_misc_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display Misc Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_counters and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_counters = not OPTIONS.display_counters end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Counters Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_movie_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_movie_info = not OPTIONS.display_movie_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display Movie Info?")
        y_pos = y_pos + delta_y
    
    elseif Options_menu.current_tab == "Cheats" then
        
        tmp = Cheat.allow_cheats and true or " "
        create_button(x_pos, y_pos, tmp, function() Cheat.allow_cheats = not Cheat.allow_cheats end)
        gui.text(x_pos + delta_x + 3, y_pos, "Allow Cheats?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        if Cheat.allow_cheats then
            local value, widget_pointer
            
            -- Lives
            value = u8(WRAM.lives)
            gui.text(x_pos, y_pos, fmt("Lives:%3d", value))
            create_button(x_pos + 9*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-", function() Cheat.change_address(WRAM.lives, -1) end)
            create_button(x_pos + 10*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+", function() Cheat.change_address(WRAM.lives, 1) end)
			y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = math.floor(128*((value)/255))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = math.floor((User_input.xmouse - x_pos)*(255/128))
                w8(WRAM.lives, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + 2*delta_y
			
			-- Bowling balls
            value = u8(WRAM.bowling_balls)
            gui.text(x_pos, y_pos, fmt("Bowling balls:%3d", value))
            create_button(x_pos + 17*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-", function() Cheat.change_address(WRAM.bowling_balls, -1) end)
            create_button(x_pos + 18*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+", function() Cheat.change_address(WRAM.bowling_balls, 1) end)
			y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = math.floor(128*((value)/255))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = math.floor((User_input.xmouse - x_pos)*(255/128))
                w8(WRAM.bowling_balls, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + 2*delta_y
			
			-- Stones
            value = u8(WRAM.stones)
            gui.text(x_pos, y_pos, fmt("Stones:%3d", value))
            create_button(x_pos + 10*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-", function() Cheat.change_address(WRAM.stones, -1) end)
            create_button(x_pos + 11*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+", function() Cheat.change_address(WRAM.stones, 1) end)
			y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = math.floor(128*((value)/255))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = math.floor((User_input.xmouse - x_pos)*(255/128))
                w8(WRAM.stones, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + 2*delta_y
            
            -- Score
            value = u16(WRAM.score)
            gui.text(x_pos, y_pos, fmt("Score:%06d", value))
            create_button(x_pos + 14*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-", function() Cheat.change_address(WRAM.score, -1, 2) end)
            create_button(x_pos + 15*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+", function() Cheat.change_address(WRAM.score, 1, 2) end)
			if value > 42767 then
				draw_text(137, y_pos, "Warning: values greater than\n042767 are shown as 000000.", COLOUR.warning)
			end
            y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = floor(128*((value)/(256*256-1)))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = floor((User_input.xmouse - x_pos)*((256*256-1)/128))
                w24(WRAM.score, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + 2*delta_y
            
            -- Timer
            value = u16(WRAM.timer)
            gui.text(x_pos, y_pos, fmt("Timer:%03d", value))
            create_button(x_pos + 11*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-", function() Cheat.change_address(WRAM.timer, -1, 2) end)
            create_button(x_pos + 12*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+", function() Cheat.change_address(WRAM.timer, 1, 2) end)
            create_button(x_pos + 14*SNES9X_FONT_WIDTH + 2, y_pos - 2, "-100", function() Cheat.change_address(WRAM.timer, -100, 2) end)
            create_button(x_pos + 18*SNES9X_FONT_WIDTH + 4, y_pos - 2, "+100", function() Cheat.change_address(WRAM.timer, 100, 2) end)
            y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = floor(128*((value)/(256*256-1)))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 128, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = floor((User_input.xmouse - x_pos)*((256*256-1)/128))
                w24(WRAM.timer, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + 2*delta_y
			
			--- Others
			gui.text(x_pos, y_pos, "Others:")
			y_pos = y_pos + delta_y
			
			-- Free Move
			tmp = Cheat.under_free_move and true or " "
			create_button(x_pos, y_pos, tmp, function() Cheat.under_free_move = not Cheat.under_free_move end)
			gui.text(x_pos + delta_x + 3, y_pos, "Free Move (Hold X to go quicker, or A to go ultra)")
			y_pos = y_pos + delta_y
			
			-- Auto-pilot for Bedrock
			tmp = OPTIONS.auto_pilot and true or " "
			create_button(x_pos, y_pos, tmp, function() OPTIONS.auto_pilot = not OPTIONS.auto_pilot end)
			gui.text(x_pos + delta_x + 3, y_pos, "Auto-pilot for Bedrock")
			y_pos = y_pos + delta_y			
			
			--- Passwords
			x_pos, y_pos = 160, 4*delta_y - 4
			gui.text(x_pos, y_pos, "Passwords:")
			y_pos = y_pos + delta_y
			
			-- Stage Skip
			tmp = OPTIONS.stage_skip and true or " "
			create_button(x_pos, y_pos, tmp, function() OPTIONS.stage_skip = not OPTIONS.stage_skip end)
			gui.text(x_pos + delta_x + 3, y_pos, "Stage Skip")
			y_pos = y_pos + delta_y
			
			-- Invincibility
			tmp = OPTIONS.invincibility and true or " "
			create_button(x_pos, y_pos, tmp, function() OPTIONS.invincibility = not OPTIONS.invincibility end)
			gui.text(x_pos + delta_x + 3, y_pos, "Invincibility")
			y_pos = y_pos + 2*delta_y
        end
        
    elseif Options_menu.current_tab == "Misc options" then
        
        tmp = OPTIONS.draw_tiles_with_click and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.draw_tiles_with_click = not OPTIONS.draw_tiles_with_click end)
        gui.text(x_pos + delta_x + 3, y_pos, "Draw tiles with left click?")
        y_pos = y_pos + delta_y
        
        create_button(x_pos, y_pos, "Erase Tiles", function() Tiletable = {} end)
        y_pos = y_pos + delta_y
        
        -- Manage opacity / filter
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, "Opacity:")
        y_pos = y_pos + delta_y
        create_button(x_pos, y_pos, "-", function() if Filter_opacity >= 1 then Filter_opacity = Filter_opacity - 1 end end)
        create_button(x_pos + delta_x + 2, y_pos, "+", function()
            if Filter_opacity <= 9 then Filter_opacity = Filter_opacity + 1 end
        end)
        gui.text(x_pos + 2*delta_x + 5, y_pos, "Change filter opacity (" .. 10*Filter_opacity .. "%)")
        y_pos = y_pos + delta_y
        
        create_button(x_pos, y_pos, "-", decrease_opacity)
        create_button(x_pos + delta_x + 2, y_pos, "+", increase_opacity)
        gui.text(x_pos + 2*delta_x + 5, y_pos, ("Text opacity: (%.0f%%, %.0f%%)"):
            format(100*Text_max_opacity, 100*Background_max_opacity))
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, ("'%s' and '%s' are hotkeys for this."):
            format(OPTIONS.hotkey_decrease_opacity, OPTIONS.hotkey_increase_opacity), COLOUR.weak)
        y_pos = y_pos + delta_y
		
		tmp = OPTIONS.display_mouse_coordinates and true or " "
		create_button(x_pos, y_pos, tmp, function() OPTIONS.display_mouse_coordinates = not OPTIONS.display_mouse_coordinates end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display mouse coordinates?")
        y_pos = y_pos + delta_y
        
        -- Others
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, "Help:")
        y_pos = y_pos + delta_y
        create_button(x_pos, y_pos, "Show tips in Snes9x: Console", Options_menu.print_help)
        
    elseif Options_menu.current_tab == "Debug info" then
	
        tmp = OPTIONS.display_debug_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_info = not OPTIONS.display_debug_info
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Some Debug Info?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        tmp = OPTIONS.display_debug_player_extra and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_player_extra = not OPTIONS.display_debug_player_extra
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Player extra info")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_sprite_extra and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_sprite_extra = not OPTIONS.display_debug_sprite_extra
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Sprite extra info")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_extended_sprite and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_extended_sprite = not OPTIONS.display_debug_extended_sprite
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Extended sprites extra info")
        y_pos = y_pos + delta_y
		
		tmp = OPTIONS.display_debug_counters and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_counters = not OPTIONS.display_debug_counters
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Values from score, timer, lives, items")
        y_pos = y_pos + delta_y		
        
        tmp = OPTIONS.display_debug_controller_data and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_controller_data = not OPTIONS.display_debug_controller_data
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Controller data (might cause desyncs!)", COLOUR.warning)
        y_pos = y_pos + delta_y
        
    elseif Options_menu.current_tab == "Sprite miscellaneous tables" then
        
        tmp = OPTIONS.display_miscellaneous_sprite_table and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_miscellaneous_sprite_table = not OPTIONS.display_miscellaneous_sprite_table
        INI.save_options() end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Miscellaneous Sprite Table?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        local opt = OPTIONS.miscellaneous_sprite_table_number
        for i = 1, 4 do
            create_button(x_pos, y_pos, opt[i] and true or " ", function()
                opt[i] = not opt[i]
                INI.save_options()
            end)
            gui.text(x_pos + delta_x + 3, y_pos, "Table " .. i)
            
            y_pos = y_pos + delta_y
        end
       
	elseif Options_menu.current_tab == "Memory edit" then
		
		tmp = Memory.allow_edit and true or " "
        create_button(x_pos, y_pos, tmp, function() Memory.allow_edit = not Memory.allow_edit apply = false end)
		gui.text(x_pos + delta_x + 3, y_pos, "Allow memory edit?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
		
		if Memory.allow_edit then
			local address = OPTIONS.address
			local value = OPTIONS.value
			local poke = true
			local freeze = false
			local size = OPTIONS.size
			local crescent = false
			Memory.edit_method = OPTIONS.edit_method
			local x_temp, y_temp
			local widget_pointer
			
			--- Address ---
			
			-- Address digits, from the right to the left
			
			local first_digit = read_digit(address, 6, 16) --floor((address-floor(address/16)*16)/1)
			local second_digit = read_digit(address, 5, 16) --floor((address-floor(address/(16^2))*(16^2))/16)
			local third_digit = read_digit(address, 4, 16) --floor((address-floor(address/(16^3))*(16^3))/(16^2))
			local fourth_digit = read_digit(address, 3, 16) --floor((address-floor(address/(16^4))*(16^4))/(16^3))
			local fifth_digit = read_digit(address, 2, 16) --floor((address-floor(address/(16^5))*(16^5))/(16^4))
			
			local address_shown = string.upper(fmt("%x", address))
			local width, height = 12, SNES9X_FONT_HEIGHT
			
			gui.text(x_pos + 1, y_pos + 13, "Address:", COLOUR.text)
			
			-- [ + ] buttons
			
			create_button(x_pos + 8*delta_x + 15, y_pos, " + ", function()
			if OPTIONS.address < 0x7F0000 then OPTIONS.address = OPTIONS.address + 0x10000 end INI.save_options() end)
			if OPTIONS.address >= 0x7f0000 then gui.text(x_pos + 8*delta_x + 16, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 28, y_pos, " + ", function()
			if OPTIONS.address + 0x1000 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x1000 end INI.save_options() end)
			if OPTIONS.address + 0x1000 > 0x800000 then gui.text(x_pos + 8*delta_x + 29, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 41, y_pos, " + ", function()
			if OPTIONS.address + 0x100 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x100 end INI.save_options() end)
			if OPTIONS.address + 0x100 > 0x800000 then gui.text(x_pos + 8*delta_x + 42, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 54, y_pos, " + ", function()
			if OPTIONS.address + 0x10 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x10 end INI.save_options() end)
			if OPTIONS.address + 0x10 > 0x800000 then gui.text(x_pos + 8*delta_x + 55, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 67, y_pos, " + ", function()
			if OPTIONS.address + 0x1 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x1 end INI.save_options() end)
			if OPTIONS.address + 0x1 >= 0x800000 then gui.text(x_pos + 8*delta_x + 68, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			y_pos = y_pos + delta_y
			
			-- Digits boxes
			
			draw_rectangle(x_pos + 8*delta_x + 2, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 15, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 28, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 41, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 54, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 67, y_pos, width, height, COLOUR.text, COLOUR.background)
			
			-- Digits
			
			x_pos = 43
			y_pos = y_pos + 1
			local colour = COLOUR.memory
			
			gui.text(x_pos, y_pos, "7", colour) x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", fifth_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", fourth_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", third_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", second_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", first_digit)), colour)  x_pos = x_pos + 13
			y_pos = y_pos + delta_y - 1
			
			-- [ - ] buttons
			
			x_pos = 4
			
			create_button(x_pos + 8*delta_x + 15, y_pos, " - ", function()
			if OPTIONS.address >= 0x7F0000 then OPTIONS.address = OPTIONS.address - 0x10000 end INI.save_options() end)
			if OPTIONS.address < 0x7F0000 then gui.text(x_pos + 8*delta_x + 16, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 28, y_pos, " - ", function()
			if OPTIONS.address - 0x1000 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x1000 end INI.save_options() end)
			if OPTIONS.address - 0x1000 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 29, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 41, y_pos, " - ", function()
			if OPTIONS.address - 0x100 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x100 end INI.save_options() end)
			if OPTIONS.address - 0x100 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 42, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 54, y_pos, " - ", function()
			if OPTIONS.address - 0x10 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x10 end INI.save_options() end)
			if OPTIONS.address - 0x10 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 55, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 67, y_pos, " - ", function()
			if OPTIONS.address > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x1 end INI.save_options() end)
			if OPTIONS.address <= 0x7E0000 then gui.text(x_pos + 8*delta_x + 68, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			--- Size ---
			
			x_pos = 5
			y_pos = 90
			
			gui.text(x_pos, y_pos, "Size:", COLOUR.text)
			
			x_temp, y_temp = 0, delta_y
			create_button(x_pos + x_temp, y_pos + y_temp, "        ", function() OPTIONS.size = 1 INI.save_options() end)
			if size == 1 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 8*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "1 byte", COLOUR.button_text, 0)
			
			x_temp = 33
			create_button(x_pos + x_temp, y_pos + y_temp, "         ", function() OPTIONS.size = 2 INI.save_options() end)
			if size == 2 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 9*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "2 bytes", COLOUR.button_text, 0)
			
			--[[ REMOVE
			x_temp = 70
			create_button(x_pos + x_temp, y_pos + y_temp, "              ", function() OPTIONS.size = 58 INI.save_options() end)
			if size == 58 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 14*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "Sprite table", COLOUR.button_text, 0)]]
			
			--- Value ---
			
			x_pos = 5
			y_pos = 135
			y_temp = 38
			
			gui.text(x_pos, y_pos, "Value:", COLOUR.text)
			gui.text(x_pos + delta_x, y_pos + delta_y, "in hex", COLOUR.text)
			gui.text(x_pos + delta_x, y_pos + y_temp, "in dec", COLOUR.text)
			
			if size == 1 or size == 58 then -- 2 digits
				-- Correction, so the value loops when you overflow/underflow
				if OPTIONS.value > 0xFF then OPTIONS.value = OPTIONS.value%256
				elseif  OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 0x100 end
				
				-- Display in decimal
				local value_dec_shown = fmt("%03d", value)
			 	draw_rectangle(x_pos + 8*delta_x, y_pos + y_temp - 1, width + 4, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + 8*delta_x + 3, y_pos + y_temp, value_dec_shown, colour)
				
				
				-- Value digits, from the right to the left
				first_digit = string.upper(fmt("%x", floor((value-floor(value/(16^2))*(16^2))/16)))
				second_digit = string.upper(fmt("%x", floor((value-floor(value/16)*16)/1)))
				
				-- [ + ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				y_pos = y_pos + delta_y
				
				-- Digits boxes
				draw_rectangle(x_pos + 8*delta_x, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 13, y_pos, width, height, COLOUR.text, COLOUR.background)
				
				-- Digits
				x_temp = 21
				y_pos = y_pos + 1
				local colour = COLOUR.memory
				
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, first_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, second_digit, colour)  x_temp = x_temp + 13
				y_pos = y_pos + delta_y - 1
				
				-- [ - ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				-- Slider button
				y_temp = 26
				
				draw_line(x_pos, y_pos + y_temp, x_pos + 128, y_pos + y_temp, 1, COLOUR.weak)  -- Snes9x: basic widget hack
				widget_pointer = math.floor(128*((value)/255))
				if mouse_onregion(x_pos, y_pos + y_temp - 2, x_pos + 128, y_pos + y_temp + 2) and User_input.leftclick then
					OPTIONS.value = math.floor((User_input.xmouse - x_pos)*(255/128))
				end
				draw_rectangle(x_pos + widget_pointer - 1, y_pos + y_temp - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
				
			elseif size == 2 then -- 4 digits
				-- Correction, so the value loops when you overflow/underflow
				if OPTIONS.value > 0xFFFF then OPTIONS.value = OPTIONS.value - 0x10000
				elseif  OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 0x10000 end
				
				-- Display in decimal
				local value_dec_shown = fmt("%05d", value)
				draw_rectangle(x_pos + 8*delta_x, y_pos + y_temp - 1, width + 12, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + 8*delta_x + 3, y_pos + y_temp, value_dec_shown, colour)
				
				-- Value digits, from the right to the left
				first_digit = string.upper(fmt("%x", floor((value-floor(value/(16^4))*(16^4))/(16^3))))
				second_digit = string.upper(fmt("%x", floor((value-floor(value/(16^3))*(16^3))/(16^2))))
				third_digit = string.upper(fmt("%x", floor((value-floor(value/(16^2))*(16^2))/16)))
				fourth_digit = string.upper(fmt("%x", floor((value-floor(value/16)*16)/1)))
				
				-- [ + ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1000 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x100 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				y_pos = y_pos + delta_y
				
				-- Digits boxes
				x_temp = 13
				
				draw_rectangle(x_pos + 8*delta_x, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 2*x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 3*x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				
				-- Digits
				x_temp = 21
				y_pos = y_pos + 1
				local colour = COLOUR.memory
				
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, first_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, second_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, third_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, fourth_digit, colour)  x_temp = x_temp + 13
				y_pos = y_pos + delta_y - 1
				
				-- [ - ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1000 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x100 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				-- Slider button
				y_temp = 26
				
				draw_line(x_pos, y_pos + y_temp, x_pos + 128, y_pos + y_temp, 1, COLOUR.weak)  -- Snes9x: basic widget hack
				widget_pointer = floor(128*((value)/(256*256-1)))
				if mouse_onregion(x_pos, y_pos + y_temp - 2, x_pos + 128, y_pos + y_temp + 2) and User_input.leftclick then
					OPTIONS.value = floor((User_input.xmouse - x_pos)*((256*256-1)/128))
				end
				draw_rectangle(x_pos + widget_pointer - 1, y_pos + y_temp - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color	
			
			end
			
			--- Sprite table ---
			
			x_pos = 135 
			y_pos = 56
			x_temp = 13*delta_x + 2
			
			gui.text(x_pos, y_pos, "Sprite table?")
			
			-- Yes/No buttons
			create_button(x_pos + x_temp, y_pos, "     ", function() OPTIONS.edit_sprite_table = true INI.save_options() end)
			if OPTIONS.edit_sprite_table then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 5*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + x_temp + 1, y_pos + 1, " Yes ", COLOUR.button_text, 0)
			
			x_temp = 18*delta_x + 3
			create_button(x_pos + x_temp, y_pos, "    ", function() OPTIONS.edit_sprite_table = false INI.save_options() end)
			if not OPTIONS.edit_sprite_table then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 4*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + x_temp + 1, y_pos + 1, " No ", COLOUR.button_text, 0)
			
			y_pos = y_pos + delta_y
			x_temp = 0
			if OPTIONS.edit_sprite_table then
				local opt = OPTIONS.edit_sprite_table_number
				for i = 1, FLINT.sprite_max + FLINT.extended_sprite_max do
					create_button(x_pos + x_temp, y_pos, "   ", function() opt[i] = not opt[i] end)
					if opt[i] then
						gui.text(x_pos + x_temp + 3, y_pos + 1, fmt("%02d", i - 1), COLOUR.positive)
					else
						gui.text(x_pos + x_temp + 3, y_pos + 1, fmt("%02d", i - 1))					
					end
				
					x_temp = x_temp + 13
					--y_pos = y_pos + delta_y
					if x_pos + x_temp > 242 then
						x_temp, y_pos = 0, y_pos + delta_y - 3
					end
				end
			end
			
			--- Mode ---
			
			x_pos = 150 
			y_pos = 115
			x_temp = 25
			
			gui.text(x_pos, y_pos, "Mode:")
			y_pos = y_pos + delta_y
			
			create_button(x_pos, y_pos, "      ", function() OPTIONS.edit_method = "Poke" INI.save_options() end)
			if Memory.edit_method == "Poke" then draw_rectangle(x_pos + 1, y_pos + 1, 6*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + delta_x + 1, y_pos + 1, "Poke", COLOUR.button_text, 0)
			
			create_button(x_pos + x_temp, y_pos, "        ", function() OPTIONS.edit_method = "Freeze" INI.save_options() end)
			if Memory.edit_method == "Freeze" then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 8*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0")
			freeze = true end
			gui.text(x_pos + x_temp + delta_x + 1, y_pos + 1, "Freeze", COLOUR.button_text, 0)
			
			--- Action ---
			
			x_pos = 150
			y_pos = 145
			
			gui.text(x_pos, y_pos, "Action:")
			y_pos = y_pos + delta_y
			
			create_button(x_pos, y_pos, "       ", function() poked = false apply = true end)
			if apply and OPTIONS.edit_method == "Freeze" then gui.text(x_pos + delta_x + 1, y_pos + 1, "APPLY", COLOUR.weak2, 0)
			else gui.text(x_pos + delta_x + 1, y_pos + 1, "APPLY", COLOUR.memory) end
			
			if OPTIONS.edit_method == "Freeze" then
				create_button(x_pos, y_pos + delta_y, "       ", function() apply = false end)
				if apply and OPTIONS.edit_method == "Freeze" then gui.text(x_pos + delta_x + 3, y_pos + delta_y + 1, "STOP", COLOUR.warning)
				else gui.text(x_pos + delta_x + 3, y_pos + delta_y + 1, "STOP", COLOUR.weak2, 0) end
			end
			
			--- Result ---
			
			x_pos = 195
			y_pos = 145
			x_temp = 8*delta_x
			
			gui.text(x_pos, y_pos, "Result:")
			gui.text(x_pos, y_pos + 2*delta_y, "in hex", COLOUR.text)
			gui.text(x_pos, y_pos + 3*delta_y, "in dec", COLOUR.text)
			
			gui.text(x_pos, y_pos + delta_y, address_shown, colour)
			if OPTIONS.edit_sprite_table then
				gui.text(x_pos + 7*delta_x, y_pos + delta_y, "(table)", colour)
			end
			
			if size == 1 then
				-- In hex
			 	draw_rectangle(x_pos + x_temp, y_pos + 2*delta_y - 1, width, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 2*delta_y,  string.upper(fmt("%02x", u8(address))), colour)
				-- In decimal
			 	draw_rectangle(x_pos + x_temp, y_pos + 3*delta_y - 1, width + 4, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 3*delta_y, fmt("%03d", u8(address)), colour)
			elseif size == 2 then
				-- In hex
				draw_rectangle(x_pos + x_temp, y_pos + 2*delta_y - 1, width + 8, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 2*delta_y,  string.upper(fmt("%04x", u16(address))), colour)	
				-- In decimal
				draw_rectangle(x_pos + x_temp, y_pos + 3*delta_y - 1, width + 12, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 3*delta_y, fmt("%05d", u16(address)), colour)				
			end
			
			if apply and poked then
				alert_text(Buffer_middle_x - 12*delta_x, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)			
			end
		end
		
    end
    
    return true
end

-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################
-- ############################################################################################################################


-- Gets input of the 1st controller / Might be deprecated someday...
local Joypad = {}
local function get_joypad()
    Joypad = joypad.get(1)
    for button, status in pairs(Joypad) do
        Joypad[button] = status and 1 or 0
    end
end

-- ############################################################
-- From gocha's

local pad_max = 2
local pad_press, pad_down, pad_up, pad_prev, pad_send = {}, {}, {}, {}, {}
local pad_presstime = {}
for player = 1, pad_max do
    pad_press[player] = {}
    pad_presstime[player] = { start=0, select=0, up=0, down=0, left=0, right=0, A=0, B=0, X=0, Y=0, L=0, R=0 }
end

local dev_press, dev_down, dev_up, dev_prev = input.get(), {}, {}, {}
local dev_presstime = {
    xmouse=0, ymouse=0, leftclick=0, rightclick=0, middleclick=0,
    shift=0, control=0, alt=0, capslock=0, numlock=0, scrolllock=0,
    ["0"]=0, ["1"]=0, ["2"]=0, ["3"]=0, ["4"]=0, ["5"]=0, ["6"]=0, ["7"]=0, ["8"]=0, ["9"]=0,
    A=0, B=0, C=0, D=0, E=0, F=0, G=0, H=0, I=0, J=0, K=0, L=0, M=0, N=0, O=0, P=0, Q=0, R=0, S=0, T=0, U=0, V=0, W=0, X=0, Y=0, Z=0,
    F1=0, F2=0, F3=0, F4=0, F5=0, F6=0, F7=0, F8=0, F9=0, F10=0, F11=0, F12=0,
    F13=0, F14=0, F15=0, F16=0, F17=0, F18=0, F19=0, F20=0, F21=0, F22=0, F23=0, F24=0,
    backspace=0, tab=0, enter=0, pause=0, escape=0, space=0,
    pageup=0, pagedown=0, ["end"]=0, home=0, insert=0, delete=0,
    left=0, up=0, right=0, down=0,
    numpad0=0, numpad1=0, numpad2=0, numpad3=0, numpad4=0, numpad5=0, numpad6=0, numpad7=0, numpad8=0, numpad9=0,
    ["numpad*"]=0, ["numpad+"]=0, ["numpad-"]=0, ["numpad."]=0, ["numpad/"]=0,
    tilde=0, plus=0, minus=0, leftbracket=0, rightbracket=0,
    semicolon=0, quote=0, comma=0, period=0, slash=0, backslash=0
}

-- Scan button presses
function scanJoypad()
    for i = 1, pad_max do
        pad_prev[i] = copytable(pad_press[i])
        pad_press[i] = joypad.get(i)
        pad_send[i] = copytable(pad_press[i])
        -- scan keydowns, keyups
        pad_down[i] = {}
        pad_up[i] = {}
        for k in pairs(pad_press[i]) do
            pad_down[i][k] = (pad_press[i][k] and not pad_prev[i][k])
            pad_up[i][k] = (pad_prev[i][k] and not pad_press[i][k])
        end
        -- count press length
        for k in pairs(pad_press[i]) do
            if not pad_press[i][k] then
                pad_presstime[i][k] = 0
            else
                pad_presstime[i][k] = pad_presstime[i][k] + 1
            end
        end
    end
end
-- Scan keyboard/mouse input
local function scanInputDevs()
    dev_prev = copytable(dev_press)
    dev_press = input.get()
    -- scan keydowns, keyups
    dev_down = {}
    dev_up = {}
    for k in pairs(dev_presstime) do
        dev_down[k] = (dev_press[k] and not dev_prev[k])
        dev_up[k] = (dev_prev[k] and not dev_press[k])
    end
    -- count press length
    for k in pairs(dev_presstime) do
        if not dev_press[k] then
            dev_presstime[k] = 0
        else
            dev_presstime[k] = dev_presstime[k] + 1
        end
    end
end
-- Send button presses
function sendJoypad()
    for i = 1, pad_max do
        joypad.set(i, pad_send[i])
    end
end

--############################################################################
-- THE FLINTSTONES FUNCTIONS:

local Game_mode, Level_index, Camera_x, Camera_y
local function scan_flintstones()
    Game_mode = u16(WRAM.game_mode)
    Level_index = u8(WRAM.level_index)
    Camera_x = s16(WRAM.camera_x)
    Camera_y = s16(WRAM.camera_y)
end


-- Converts the in-game (x, y) to SNES-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_screen = (x - camera_x)
    local y_screen = (y - camera_y) - Y_CAMERA_OFF
    
    return x_screen, y_screen
end


-- Converts Snes9x-screen coordinates to in-game (x, y)
local function game_coordinates(x_snes9x, y_snes9x, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_game = x_snes9x + camera_x
    local y_game = y_snes9x + Y_CAMERA_OFF + camera_y
    
    return x_game, y_game
end


local function draw_tilesets(camera_x, camera_y)
    local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, camera_x, camera_y)
    x_mouse = 16*math.floor(x_mouse/16)
    y_mouse = 16*math.floor(y_mouse/16)
    
    for number, positions in ipairs(Tiletable) do
        -- Calculate the Lsnes coordinates
        local left = positions[1] + x_origin
        local top = positions[2] + y_origin
        local right = left + 15
        local bottom = top + 15
        local x_game, y_game = game_coordinates(left, top, camera_x, camera_y)
        
        -- Returns if block is way too outside the screen
        if left > - Border_left - 32 and top  > - Border_top - 32 and -- Snes9x: w/ 2*
        right < Screen_width  + Border_right + 32 and bottom < Screen_height + Border_bottom + 32 then
            
			draw_rectangle(left, top, 15, 15, COLOUR.block, 0)
			--display_boundaries(x_game, y_game, 16, 16, camera_x, camera_y)  -- the text around it
        end
    end
end


-- if the user clicks in a tile, it will be be drawn
-- if click is onto drawn region, it'll be erased
-- there's a max of possible tiles
-- Tileset[n] is a triple compound of {x, y, draw info?}
local function select_tile()
    if not OPTIONS.draw_tiles_with_click then return end
    if Game_mode ~= FLINT.game_mode_level then return end
    
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    x_mouse = 16*floor(x_mouse/16)
    y_mouse = 16*floor(y_mouse/16)
    
    for number, positions in ipairs(Tiletable) do  -- if mouse points a drawn tile, erase it
        if x_mouse == positions[1] and y_mouse == positions[2] then
            if Tiletable[number][3] == false then
                Tiletable[number][3] = true
            else
                table.remove(Tiletable, number)
            end
            
            return
        end
    end
    
    -- otherwise, draw a new tile
    if #Tiletable == OPTIONS.max_tiles_drawn then
        table.remove(Tiletable, 1)
        Tiletable[OPTIONS.max_tiles_drawn] = {x_mouse, y_mouse, false}
    else
        table.insert(Tiletable, {x_mouse, y_mouse, false})
    end
    
end


-- uses the mouse to select an object
local function select_object(mouse_x, mouse_y, camera_x, camera_y)
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 0.5
    
    local x_game, y_game = game_coordinates(mouse_x, mouse_y, camera_x, camera_y)
    local obj_id
    
    -- Checks if the mouse is over Fred
    local x_player = s16(WRAM.x)
    local y_player = s16(WRAM.y)
	local x1 = s16(WRAM.hitbox_corner1_x) --\
	local y1 = s16(WRAM.hitbox_corner1_y) -- \ hitbox rectangle with corners 1 and 2
	local x2 = s16(WRAM.hitbox_corner2_x) -- /
	local y2 = s16(WRAM.hitbox_corner2_y) --/
	
	if x2 >= x_game and x1 <= x_game and y2 >= y_game and y1 <= y_game then
		obj_id = "Fred"
	end
	
    
    if not obj_id and OPTIONS.display_sprite_info then
		local counter = 0 -- REMOVE
        for id = 0, 2*FLINT.sprite_max - 1, 2 do
            local sprite_type = u8(WRAM.sprite_type + id)
            if sprite_type ~= 0 and Sprites_info[id].x then -- TODO: see why the script gets here without exporting Sprites_info
                -- Import some values
                local x_sprite, y_sprite = Sprites_info[id].x, Sprites_info[id].y
                local x_screen, y_screen = Sprites_info[id].x_screen, Sprites_info[id].y_screen
                local box_type = Sprites_info[id].box_type
                local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
                local width, height = Sprites_info[id].width, Sprites_info[id].height
				--draw_text(115, 32 + counter*8, fmt("%d: %d", id/2, Sprites_info[id].sprite_type)) -- REMOVE
               
                if x_sprite + xoff + width >= x_game and x_sprite + xoff <= x_game and
                y_sprite + yoff + height >= y_game and y_sprite + yoff <= y_game then
                    obj_id = id/2
                    break
                end
				
				counter = counter + 1
            end
        end
    end
    
    if not obj_id then return end
    
    draw_text(User_input.xmouse, User_input.ymouse - 8, obj_id, true, false, 0.5, 1.0)
    return obj_id, x_game, y_game
end


-- This function sees if the mouse if over some object, to change its hitbox mode
-- The order is: 1) player, 2) sprite.
local function right_click()
    local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    if id == nil then return end
    
    if tostring(id) == "Fred" then
        
		if OPTIONS.display_player_hitbox and OPTIONS.display_interaction_points and OPTIONS.display_club_hitbox then
			OPTIONS.display_interaction_points = false
		elseif OPTIONS.display_player_hitbox and OPTIONS.display_club_hitbox then
			OPTIONS.display_club_hitbox = false
			OPTIONS.display_interaction_points = true
		elseif OPTIONS.display_player_hitbox and OPTIONS.display_interaction_points then
			OPTIONS.display_club_hitbox = true
			OPTIONS.display_player_hitbox = false
		elseif OPTIONS.display_club_hitbox and OPTIONS.display_interaction_points then
			OPTIONS.display_player_hitbox = false
			OPTIONS.display_interaction_points = false
		elseif OPTIONS.display_club_hitbox then
			OPTIONS.display_club_hitbox = false
			OPTIONS.display_player_hitbox = true
		elseif OPTIONS.display_player_hitbox then
			OPTIONS.display_player_hitbox = false
			OPTIONS.display_interaction_points = true
		elseif OPTIONS.display_interaction_points then
			OPTIONS.display_player_hitbox = false
			OPTIONS.display_interaction_points = false
			OPTIONS.display_club_hitbox = false
		else --if all false then
			OPTIONS.display_player_hitbox = true
			OPTIONS.display_interaction_points = true
			OPTIONS.display_club_hitbox = true
		end
        
    end
    --[[ -- TODO
    local spr_id = tonumber(id)
    if spr_id and spr_id >= 0 and spr_id <= 2*FLINT.sprite_max - 1 then
        
        local number = Sprites_info[spr_id].number
        if Sprite_hitbox[spr_id][number].sprite and Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = false
            Sprite_hitbox[spr_id][number].block = false
        elseif Sprite_hitbox[spr_id][number].sprite then
            Sprite_hitbox[spr_id][number].block = true
            Sprite_hitbox[spr_id][number].sprite = false
        elseif Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = true
        else
            Sprite_hitbox[spr_id][number].sprite = true
        end
        
    end ]]
end


local function show_movie_info()
    if not OPTIONS.display_movie_info then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    local y_text = - Border_top
    local x_text = 0
    local width = SNES9X_FONT_WIDTH
    
    local rec_color = (Readonly or not Movie_active) and COLOUR.text or COLOUR.warning
    local recording_bg = (Readonly or not Movie_active) and COLOUR.background or COLOUR.warning_bg 
    
    -- Read-only or read-write?
    local movie_type = (not Movie_active and "No movie ") or (Readonly and "Movie " or "REC ")
    alert_text(x_text, y_text, movie_type, rec_color, recording_bg)
    
    -- Frame count
    x_text = x_text + width*string.len(movie_type)
    local movie_info
    if Readonly then
        movie_info = string.format("%d/%d", Lastframe_emulated, Framecount)
    else
        movie_info = string.format("%d", Lastframe_emulated)
    end
    draw_text(x_text, y_text, movie_info)  -- Shows the latest frame emulated, not the frame being run now
    x_text = x_text + width*string.len(movie_info)
    
    -- Rerecord count
    local rr_info = string.format(" %d ", Rerecords)
    draw_text(x_text, y_text, rr_info, COLOUR.weak)
    x_text = x_text + width*string.len(rr_info)
    
    -- Lag count
    draw_text(x_text, y_text, Lagcount, COLOUR.warning)
    
    local str = frame_time(Lastframe_emulated)    -- Shows the latest frame emulated, not the frame being run now
    alert_text(Buffer_width, Buffer_height, str, COLOUR.text, recording_bg, false, 1.0, 1.0)
    
    if Is_lagged then
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 2*SNES9X_FONT_HEIGHT, " LAG ", COLOUR.warning, COLOUR.warning_bg)
        emu.message("Lag detected!") -- Snes9x
        
    end
    
end


local function show_misc_info()
    if not OPTIONS.display_misc_info then return end
    
    -- Font
    Text_opacity = Game_mode == FLINT.game_mode_level and 0.8 or 1.0 -- Snes9x
    Bg_opacity = 1.0
    
    -- Display
    local game_mode = string.upper(fmt("%04x", Game_mode))
    
	if Game_mode == FLINT.game_mode_level then
		draw_text(130, 0, fmt("Camera (%d, %d)", Camera_x, Camera_y))
	
		if OPTIONS.display_debug_counters then
			local score = u16(WRAM.score)
			local timer = u16(WRAM.timer)
			local lives = u8(WRAM.lives)
			local bowling_balls = u8(WRAM.bowling_balls)
			local stones = u8(WRAM.stones)
			-- because values greater than these are not shown properly
			if score > 42767 then draw_text(66, 16, fmt("=%d", score), COLOUR.weak) end
			if timer > 999 then draw_text(Buffer_width + Border_right - 69, 16, fmt("%6d=", timer), COLOUR.weak) end
			if lives > 99 then draw_text(104, 204, fmt("=%d", lives), COLOUR.weak) end
			if bowling_balls > 99 then draw_text(144, 204, fmt("=%d", bowling_balls), COLOUR.weak) end
			if stones > 99 then draw_text(184, 204, fmt("=%d", stones), COLOUR.weak) end		
		end    
	end
	
	draw_text(Buffer_width + Border_right - 20, -Border_top, fmt("Mode:%s", game_mode), true, false)
	
	local stage_skip = u8(WRAM.stage_skip) if stage_skip == 0 then stage_skip = "OFF" else stage_skip = "ON" end
	local invincibility = u8(WRAM.invincibility) if invincibility == 0 then invincibility = "OFF" else invincibility = "ON" end
	draw_text(1, Buffer_height - Border_bottom - 25, fmt("Stage Skip:%s", stage_skip))
	draw_text(1, Buffer_height - Border_bottom - 16, fmt("Invincibility:%s", invincibility))
end


-- Display mouse coordinates right above it
local function show_mouse_info()
	if not OPTIONS.display_mouse_coordinates then return end
	
	-- Font
    Text_opacity = 1.0 -- Snes9x
    Bg_opacity = 1.0
	
	local x = User_input.xmouse
	local y = User_input.ymouse
	
	if User_input.xmouse >= 0 and User_input.xmouse <= 256 and User_input.ymouse >= 0 and User_input.ymouse <= 224 then
		alert_text(x, y - 8, fmt("(%d, %d)", x, y), COLOUR.text, COLOUR.background, 0.1, 0.5)
	end
end


-- Shows the controller input as the RAM and SNES registers store it
local function show_controller_data()
    if not (OPTIONS.display_debug_info and OPTIONS.display_debug_controller_data) then return end
    
    -- Font
    Text_opacity = 0.9
    local height = SNES9X_FONT_HEIGHT
    local x_pos, y_pos, x, y, _ = 0, 0, 0, SNES9X_FONT_HEIGHT
    
    local controller = memory.readword(0x1000000 + 0x4218) -- Snes9x / BUS area
    x = draw_over_text(x, y, controller, "BYsS^v<>AXLR0123", COLOUR.warning, false, true)
    _, y = draw_text(x, y, " (Registers)", COLOUR.warning, false, true)
    
    x = x_pos
    x = draw_over_text(x, y, 256*u8(WRAM.ctrl_1_1) + u8(WRAM.ctrl_1_2), "BYsS^v<>AXLR0123", COLOUR.weak)
    _, y = draw_text(x, y, " (RAM data)", COLOUR.weak, false, true)
    
    x = x_pos
    draw_over_text(x, y, 256*u8(WRAM.firstctrl_1_1) + u8(WRAM.firstctrl_1_2), "BYsS^v<>AXLR0123", 0, "#0xffff", 0) -- Snes9x
end


local function level_info()
    if not OPTIONS.display_level_info then return end
    
    -- Font
    Text_opacity = 0.8
    Bg_opacity = 1.0
    local color = COLOUR.text
	
	local x_pos = 130
	local y_pos
	if OPTIONS.display_misc_info then y_pos = 8 else y_pos = 0 end
    
	local level_name, level
	if Level_index == 0x00 then level_name = "Quarry 1" elseif Level_index == 0x01 then level_name = "Quarry 2" elseif Level_index == 0x02 then level_name = "Bedrock 1"
	elseif Level_index == 0x04 then level_name = "Jungle 3" elseif Level_index == 0x05 then level_name = "Jungle 2" elseif Level_index == 0x06 then level_name = "Jungle 1" 
	elseif Level_index == 0x07 then level_name = "Volcanic 1" elseif Level_index == 0x08 then level_name = "Volcanic 2" elseif Level_index == 0x09 then level_name = "Volcanic 3"
	elseif Level_index == 0x0C then level_name = "Machine 1" elseif Level_index == 0x0D then level_name = "Machine 2" elseif Level_index == 0x0E then level_name = "Machine 3"
	elseif Level_index == 0x10 then level_name = "Quarry 3" elseif Level_index == 0x11 then level_name = "Jungle 4" end
	level = string.upper(fmt("%02x", Level_index))
	
    draw_text(x_pos, y_pos, fmt("Level:%s (%s)", level, level_name), color, true, false)
	
	--- Extra help/info
	if OPTIONS.display_level_help then
		-- A small help with those annoying mud platforms (Jungle 3)
		if Level_index == 0x04 then 
			local x1, y1 = screen_coordinates(3088, 560, Camera_x, Camera_y)
			local x2, y2 = screen_coordinates(3170, 560, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3186, 560, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3248, 560, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3248, 540, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3186, 540, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3264, 560, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3312, 560, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3328, 560, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3408, 560, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3408, 540, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3328, 540, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
		
			x1, y1 = screen_coordinates(3424, 560, Camera_x, Camera_y)
			x2, y2 = screen_coordinates(3472, 560, Camera_x, Camera_y)
			draw_arrow(x1, y1, x2, y2, COLOUR.very_weak)
	
		-- A line guide for the coconuts trajectory (Jungle 4)
		elseif Level_index == 0x11 then
			draw_box(20, 0, 28, 224, "#ffa500aa", COLOUR.detection_bg) -- warning_soft with transparency
			draw_box(52, 0, 60, 224, "#ffa500aa", COLOUR.detection_bg)
			draw_box(84, 0, 92, 224, "#ffa500aa", COLOUR.detection_bg)
			draw_box(116, 0, 124, 224, "#ffa500aa", COLOUR.detection_bg)
			draw_box(148, 0, 156, 224, "#ffa500aa", COLOUR.detection_bg)
			draw_box(180, 0, 188, 224, "#ffa500aa", COLOUR.detection_bg)
			draw_box(212, 0, 220, 224, "#ffa500aa", COLOUR.detection_bg)
			
		-- Lava flood position (Volcanic 2)
		elseif Level_index == 0x08 then
			local lava_flood_y_static = u16(WRAM.lava_flood_y_static)
			local lava_flood_y_oscillating = u16(WRAM.lava_flood_y_oscillating)
			local fred_y = u16(WRAM.y)
			local x1, y1 = 207, 204
			local x2, y2 = screen_coordinates(200, lava_flood_y_static, Camera_x, Camera_y) -- x2 doesn't matter here
			local x3, y3 = screen_coordinates(200, lava_flood_y_oscillating, Camera_x, Camera_y) -- x3 doesn't matter here
			x2 = 207
			if y2 < 224 then y1 = y2 - 20 end
			local color = COLOUR.memory -- cyan
			
			draw_arrow(x1, y1, x2, y3, color)
			draw_line(x1, y1, 256, y1, 1, color)
			draw_text(x1 + 1, y1 - SNES9X_FONT_HEIGHT, fmt("Lava y: %d", lava_flood_y_static), color)
			draw_text(Buffer_width + Border_right, y1 + 2, fmt("(%+d)", lava_flood_y_static - fred_y), color, true)
		
		-- Lava wave position and hitbox (Volcanic 3)
		elseif Level_index == 0x09 then
			local lava_wave_x = s16(WRAM.lava_wave_x)
			local lava_wave_y = s16(WRAM.lava_wave_y)
			local x1, y1 = screen_coordinates(lava_wave_x, lava_wave_y, Camera_x, Camera_y)
			local x2, y2 = x1 + 155, 224 -- 139
			local color = COLOUR.memory -- cyan
			
			gui.crosshair(x1, y1, 2)
			if lava_wave_y == 112 then
				draw_box(x1 - 300, 0, x2, y2, color, COLOUR.detection_bg)
			end
		end
	end
end


-- Displays player's hitbox
local function player_hitbox()
    local x = s16(WRAM.x)
    local y = s16(WRAM.y)
	local x1 = s16(WRAM.club_hitbox_corner1_x)
	local y1 = s16(WRAM.club_hitbox_corner1_y)
	local x2 = s16(WRAM.club_hitbox_corner2_x)
	local y2 = s16(WRAM.club_hitbox_corner2_y)
	local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    local x_screen1, y_screen1 = screen_coordinates(x1, y1, Camera_x, Camera_y)
    local x_screen2, y_screen2 = screen_coordinates(x2, y2, Camera_x, Camera_y)
	
	--Car bounce hitbox (Bedrock 1)
	if Level_index == 0x02 then
		local x_1, y_1 = s16(0x09BC), s16(0x0A00) -- coordinates of sprite on slot #25
		local x_2, y_2 = s16(0x09B8), s16(0x09FC) -- coordinates of sprite on slot #23
		local x_1screen, y_1screen = screen_coordinates(x_1, y_1, Camera_x, Camera_y)
		local x_2screen, y_2screen = screen_coordinates(x_2, y_2, Camera_x, Camera_y)
		
		draw_box(x_1screen + 16, y_1screen, x_2screen, y_2screen, COLOUR.Fred, COLOUR.Fred_bg)
		return
	end
	
	-- Club hitbox (when smashing)
	if OPTIONS.display_club_hitbox then		
		draw_box(x_screen1, y_screen1, x_screen2, y_screen2, "#00aaaa", "#00aaaa22")--"#ff0000ff", "#ff000055")
	end
    
    -- Collision with sprites
    if OPTIONS.display_player_hitbox then
		x1 = s16(WRAM.hitbox_corner1_x)
		y1 = s16(WRAM.hitbox_corner1_y)
		x2 = s16(WRAM.hitbox_corner2_x)
		y2 = s16(WRAM.hitbox_corner2_y)
		x_screen1, y_screen1 = screen_coordinates(x1, y1, Camera_x, Camera_y)
		x_screen2, y_screen2 = screen_coordinates(x2, y2, Camera_x, Camera_y)
		
        draw_box(x_screen1, y_screen1, x_screen2, y_screen2, COLOUR.Fred, COLOUR.Fred_bg)--"#ff0000ff", "#ff000055")        
    end
    
    -- Interaction points (collision with blocks and sprite platforming)
    if OPTIONS.display_interaction_points then
		--- Block collision
		local x_interaction, y_interaction = x_screen + 16, y_screen + 48
		--- Sprite platforming
		local x_left, y_left = s16(WRAM.sprite_platforming_left_x), s16(WRAM.sprite_platforming_left_y) - 2
		local x_right, y_right = s16(WRAM.sprite_platforming_right_x), s16(WRAM.sprite_platforming_right_y) + 3
		local x_screen_left, y_screen_left = screen_coordinates(x_left, y_left, Camera_x, Camera_y)
		local x_screen_right, y_screen_right = screen_coordinates(x_right, y_right, Camera_x, Camera_y)
		
		local color = COLOUR.interaction
		
		-- dark filter to make easier to see
		local y_temp if y_screen_right >= y_interaction then y_temp = y_screen_right else y_temp = y_interaction end
        draw_box(x_screen_left - 2, y_interaction - 18, x_screen_right + 2, y_temp + 2, COLOUR.interaction_nohitbox, COLOUR.interaction_nohitbox_bg)
		
		--- Block collision
		-- vertical lines
		gui.line(x_interaction, y_interaction - 16, x_interaction, y_interaction, color)
		-- horizontal lines
		gui.line(x_interaction - 3, y_interaction - 16, x_interaction + 3, y_interaction - 16, color)
		gui.line(x_interaction - 3, y_interaction, x_interaction + 3, y_interaction, color)
		
		--- Sprite platforming
		-- left
		gui.line(x_screen_left, y_screen_left, x_screen_left + 3, y_screen_left, color)
		gui.line(x_screen_left, y_screen_left, x_screen_left, y_screen_left - 3, color)
		-- right
		gui.line(x_screen_right, y_screen_right, x_screen_right - 3, y_screen_right, color)
		gui.line(x_screen_right, y_screen_right, x_screen_right, y_screen_right - 3, color)
	end
	
	
end


local function player()
	
	-- Display Fred's hitbox
	player_hitbox()
	
    if not OPTIONS.display_player_info then
        draw_text(0, 32, "Player info: off", COLOUR.weak2)
        return
    end
	
    -- Font
    Text_opacity = 1.0
    
    -- Reads WRAM
    local x = s16(WRAM.x)
    local y = s16(WRAM.y)
    local x_sub = u8(WRAM.x_sub)
    local y_sub = u8(WRAM.y_sub)
    local direction = u8(WRAM.direction)
    local x_speed = s8(WRAM.x_speed)
    local x_subspeed = u8(WRAM.x_subspeed)
    local y_speed = s8(WRAM.y_speed)
    local y_subspeed = u8(WRAM.y_subspeed)
    local on_ground = u8(WRAM.on_ground)
	local last_valid_x = s16(WRAM.last_valid_x)
	local last_valid_y = s16(WRAM.last_valid_y)
	local status = u8(WRAM.status)
	local is_smashing = u8(WRAM.is_smashing)
	local lives = u8(WRAM.lives) -- still unused in the script
	local health = u8(WRAM.health) -- still unused in the script
	local stones = u8(WRAM.stones) -- still unused in the script
	local bowling_balls = u8(WRAM.bowling_balls) -- still unused in the script
	local score = u8(WRAM.score) -- still unused in the script
	local throw_power = u8(WRAM.throw_power)
    
    -- Display info
    local i = 0
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT
    local table_x = 0
    local table_y = AR_y*32
	local temp_colour
	local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    
	if direction == 0 then direction = RIGHT_ARROW else direction = LEFT_ARROW end
    draw_text(table_x, table_y + i*delta_y, fmt("Pos (%+d.%02x, %+d.%02x) %s", x, x_sub, y, y_sub, direction))
    i = i + 1
    
	if x_speed < 0 then -- corretions for speed to the left
		x_speed = x_speed + 1
		x_subspeed = 0xff - x_subspeed + 1
		if x_subspeed == 0x100 then x_subspeed = 0 ; x_speed = x_speed - 1 end
		if x_speed == 0 then draw_text(table_x, table_y + i*delta_y, fmt("Speed (-%d.%02x, %+d.%02x)", x_speed, x_subspeed, y_speed, y_subspeed))
		else draw_text(table_x, table_y + i*delta_y, fmt("Speed (%d.%02x, %+d.%02x)", x_speed, x_subspeed, y_speed, y_subspeed)) end
	else
		draw_text(table_x, table_y + i*delta_y, fmt("Speed (%+d.%02x, %+d.%02x)", x_speed, x_subspeed, y_speed, y_subspeed))
	end
    i = i + 1   
    
	if on_ground == 0 then on_ground = "no" temp_colour = COLOUR.warning else on_ground = "yes" temp_colour = COLOUR.positive end
	draw_text(table_x, table_y + i*delta_y, fmt("On ground:"))
	draw_text(table_x + 10*delta_x + 2, table_y + i*delta_y, fmt("%s", on_ground), temp_colour)
	i = i + 1
	
	status = string.upper(fmt("%02x", status))
	draw_text(table_x, table_y + i*delta_y, fmt("Status: %s", status))
	i = i + 1
	
	if is_smashing == 0 then is_smashing = "no" temp_colour = COLOUR.warning else is_smashing = "yes" temp_colour = COLOUR.positive end
	draw_text(table_x, table_y + i*delta_y, fmt("Smashing:"))
	draw_text(table_x + 9*delta_x + 2, table_y + i*delta_y, fmt("%s", is_smashing), temp_colour)
	i = i + 1

	if throw_power >= 63 and throw_power < 100 then temp_colour = "#ffa500"
	elseif throw_power >= 100 then temp_colour = COLOUR.warning else temp_colour = COLOUR.text end
	draw_text(table_x, table_y + i*delta_y, fmt("Throw power:", throw_power))
	draw_text(table_x + 12*delta_x + 1, table_y + i*delta_y, fmt("%d", throw_power), temp_colour)
	i = i + 1
	
	draw_text(table_x, table_y + i*delta_y, fmt("Last valid pos\n(%+d, %+d)", last_valid_x, last_valid_y))
	i = i + 2
	
	-- Fred's position cross
	if OPTIONS.display_debug_info then
		gui.crosshair(x_screen, y_screen, 2, COLOUR.text)
	end
	
	-- Stone trajectory based on throw power
	if OPTIONS.display_stone_trajectory and throw_power ~= 0 then
		local dir, x_off, x_base
		if direction == RIGHT_ARROW then
			dir = 1
			x_off = 64
		else
			dir = -1
			x_off = -8
		end
		
		-- crescent line
		for k = 0, throw_power, 3 do
			gui.gdoverlay(floor((2*x_screen + x_off + dir*k*7)/2), floor((2*y_screen + 24)/2), IMAGES.stone_animation[k%(#IMAGES.stone_animation)+1], 
							Background_max_opacity * Bg_opacity) -- alternately: "◯", COLOUR.warning_soft)	
		end	
		
		-- arc
		x_base = 2*x_screen + x_off + dir*(throw_power - 1)*7
		y_base = 2*y_screen + 24
		gui.gdoverlay(floor((x_base + dir*24)/2), floor((y_base + 1)/2), IMAGES.stone_animation[1], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*48)/2), floor((y_base + 3)/2), IMAGES.stone_animation[2], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*70)/2), floor((y_base + 12)/2), IMAGES.stone_animation[3], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*92)/2), floor((y_base + 23)/2), IMAGES.stone_animation[4], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*114)/2), floor((y_base + 36)/2), IMAGES.stone_animation[5], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*136)/2), floor((y_base + 52)/2), IMAGES.stone_animation[6], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*156)/2), floor((y_base + 71)/2), IMAGES.stone_animation[7], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*176)/2), floor((y_base + 93)/2), IMAGES.stone_animation[1], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*196)/2), floor((y_base + 119)/2), IMAGES.stone_animation[2], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*216)/2), floor((y_base + 147)/2), IMAGES.stone_animation[3], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*236)/2), floor((y_base + 179)/2), IMAGES.stone_animation[4], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*256)/2), floor((y_base + 214)/2), IMAGES.stone_animation[5], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*276)/2), floor((y_base + 253)/2), IMAGES.stone_animation[6], Background_max_opacity * Bg_opacity)
		gui.gdoverlay(floor((x_base + dir*296)/2), floor((y_base + 295)/2), IMAGES.stone_animation[7], Background_max_opacity * Bg_opacity)
	end
	
	--
	local address_x, address_y = 0x00D7, 0x00DB
	local x_temp, y_temp = 106, 32
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, COLOUR.text)
	--draw_text(x_screen, y_screen - delta_y, "1", COLOUR.text)
	--draw_text(x_temp, y_temp, fmt("1: %04x-%04x", address_x, address_y), COLOUR.text) y_temp = y_temp + delta_y
	
	address_x, address_y = address_x + 2, address_y + 2
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, "#ff0000")
	--draw_text(x_screen, y_screen - delta_y, "2", "#ff0000")
	--draw_text(x_temp, y_temp, fmt("2: %04x-%04x", address_x, address_y), "#ff0000") y_temp = y_temp + delta_y
	
	address_x, address_y = address_x + 6, address_y + 6
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, "#ffff00")
	--draw_text(x_screen, y_screen - delta_y, "3", "#ffff00")
	--draw_text(x_temp, y_temp, fmt("3: %04x-%04x", address_x, address_y), "#ffff00") y_temp = y_temp + delta_y
	--draw_line(x_screen, y_screen - 2, x_screen + 18, y_screen - 2, 1, "#ffff00") -- TALVEZ TIRAR o -2
	
	address_x, address_y = address_x + 2, address_y + 2
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, "#00ff00")
	--draw_text(x_screen, y_screen - delta_y, "4", "#00ff00")
	--draw_text(x_temp, y_temp, fmt("4: %04x-%04x", address_x, address_y), "#00ff00") y_temp = y_temp + delta_y
	
	address_x, address_y = address_x + 6, address_y + 6
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, "#00ffff")
	--draw_text(x_screen, y_screen - delta_y, "5", "#00ffff")
	--draw_text(x_temp, y_temp, fmt("5: %04x-%04x", address_x, address_y), "#00ffff") y_temp = y_temp + delta_y
	
	address_x, address_y = address_x + 2, address_y + 2
	x, y = s16(address_x), s16(address_y)
	x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	--gui.crosshair(x_screen, y_screen, 1, COLOUR.warning_soft)	
	--draw_text(x_screen, y_screen - delta_y, "6", COLOUR.warning_soft)
	--draw_text(x_temp, y_temp, fmt("6: %04x-%04x", address_x, address_y), COLOUR.warning_soft)
	
end


local function extended_sprites() --TODO: add trajectory on the thrown stone    
    -- Font
    Text_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    
	local table_x = 0
    local table_y = AR_y*120
    local counter = 0
    for id = 0, 2*FLINT.extended_sprite_max - 1, 2 do
        local extsprite_type = u8(WRAM.extsprite_type + id)
        
        if extsprite_type ~= 0 then
            -- Reads WRAM addresses
            local x = s16(WRAM.extsprite_x + id)
            local y = s16(WRAM.extsprite_y + id)
            local x_sub = u8(WRAM.extsprite_x_sub + id)
            local y_sub = u8(WRAM.extsprite_y_sub + id)
            local x_speed = s8(WRAM.extsprite_x_speed + id)
            local x_subspeed = u8(WRAM.extsprite_x_subspeed + id)
            local y_speed = s8(WRAM.extsprite_y_speed + id)
            local y_subspeed = u8(WRAM.extsprite_y_subspeed + id)
            
			---**********************************************
			-- Display
			
			-- Calculates the extended sprites screen positions
			local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
			
			-- Calculates the correct color to use, according to id
			local extsprite_color = COLOUR.extsprites[(id/2)%(#COLOUR.extsprites) + 1]
			
			-- Adjusts the opacity if it's offscreen
			if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
				Text_opacity = 0.8
			else
				Text_opacity = 0.5
			end
			
			---**********************************************
			-- Prints
			if OPTIONS.display_extended_sprite_info then
			
				-- Table
				extsprite_type = string.upper(fmt("%02x", extsprite_type))
				local extsprite_string = fmt("<%02d> %s (%d.%02x, %d.%02x)", id/2, extsprite_type, x, x_sub, y, y_sub)
				draw_text(table_x, table_y + counter*height, extsprite_string , extsprite_color, true, false)
			
				-- Prints information next to the exteded sprite
				draw_text(x_screen + 6, y_screen - 5, fmt("<%02d>", id/2), extsprite_color, COLOUR.background, COLOUR.halo, true)
			
				-- Extended sprite position pixel and cross
				draw_pixel(x_screen, y_screen, extsprite_color, COLOUR.background)
				if OPTIONS.display_debug_extended_sprite then
					gui.crosshair(x_screen, y_screen, 2, extsprite_color)
				end
			
			end
			
			---**********************************************
			-- Displays extended sprite hitbox
			if OPTIONS.display_extended_sprite_hitbox then
	
				local box_type = u8(0x06e0 + (id + 58 + 2)) -- +58 to jump over the sprite table

				local rom1 = memory.readbyte(0x83b9d9 + box_type) -- $d9
				local rom2 = memory.readbyte(0x83b9dd + box_type) -- $dd
				local rom3 = memory.readbyte(0x83b9db + box_type) -- $d7
				local rom4 = memory.readbyte(0x83b9df + box_type) -- $db
	
				draw_box(x_screen + rom3, y_screen + rom4, x_screen + rom1, y_screen + rom2, extsprite_color)
			
			end
            
            counter = counter + 1
        end
    end
    
    Text_opacity = 0.7
	
	if OPTIONS.display_extended_sprite_info then
		draw_text(table_x, table_y, fmt("Ext. sprites:%2d ", counter), COLOUR.weak, true, false, 0.0, 1.0)
	else
        draw_text(table_x, table_y, "Ext. sprite info: off", COLOUR.weak2)
	end
end

local sprite_routines_executed = false
local x_ref, y_ref
local function sprite_info(id, counter, table_position)
    Text_opacity = 1.0
	Bg_opacity = 1.0
    
    local sprite_type = u8(WRAM.sprite_type + id)
    if sprite_type == 0 then return 0 end  -- returns if the slot is empty
	sprite_type = string.upper(fmt("%02x", sprite_type)) -- to make it easier to read
    
    -- Reads WRAM addresses
    local x = s16(WRAM.sprite_x + id)
    local y = s16(WRAM.sprite_y + id)
    local x_sub = u8(WRAM.sprite_x_sub + id)
    local y_sub = u8(WRAM.sprite_y_sub + id)
    local x_speed = s8(WRAM.sprite_x_speed + id)
    local x_subspeed = u8(WRAM.sprite_x_subspeed + id)
    local y_speed = s8(WRAM.sprite_y_speed + id)
    local y_subspeed = u8(WRAM.sprite_y_subspeed + id)
	local misc1 = u16(WRAM.sprite_miscellaneous1 + id)
	local misc2 = u16(WRAM.sprite_miscellaneous2 + id)
	local misc3 = u16(WRAM.sprite_miscellaneous3 + id)
	local misc4 = u16(WRAM.sprite_miscellaneous4 + id)
	local boss_hp = u8(WRAM.boss_hp)
    
    
    -- Let x and y be 16-bit signed
    --x = signed(x, 16)
    --y = signed(y, 16)
    
    ---**********************************************
	-- Display
	
    -- Calculates the sprites screen positions
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    
    -- Calculates the correct color to use, according to id
    local sprite_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1]
    local color_background = COLOUR.sprites_bg
    
    ---**********************************************
    -- Special sprites analysis:
    
	-- Draw Big falling lava boulder detection area
	if sprite_type == "4F" and misc2 == 0 then
		draw_box(x_screen + 1, -1, x_screen + 31, 224, sprite_color, COLOUR.detection_bg)
	end
	
	-- Draw Falling lava boulder detection area (is different for each boulder in the level)
	if sprite_type == "51" and misc2 == 0 then
		if x < 500 then
			draw_box(x_screen + 17, y_screen + 49, x_screen + 47, y_screen + 175, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen + 10, y_screen + 165, sprite_color)
			draw_arrow(x_screen + 10, y_screen + 165, x_screen + 60, y_screen + 165, sprite_color)
		elseif x < 3100 then
			draw_box(x_screen - 159, y_screen + 129, x_screen - 129, y_screen + 255, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen - 60, y_screen + 210, sprite_color)
			draw_arrow(x_screen - 60, y_screen + 210, x_screen - 170, y_screen + 210, sprite_color)
		elseif x < 3201 then
			draw_box(x_screen + 17, y_screen + 129, x_screen + 47, y_screen + 255, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen + 80, y_screen + 200, sprite_color)
			draw_arrow(x_screen + 80, y_screen + 200, x_screen - 0, y_screen + 235, sprite_color)
		elseif x < 3300 then
			draw_box(x_screen - 191, y_screen + 161, x_screen - 161, y_screen + 287, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen - 60, y_screen + 220, sprite_color)
			draw_arrow(x_screen - 60, y_screen + 220, x_screen - 210, y_screen + 220, sprite_color)
		elseif x < 3540 then
			draw_box(x_screen - 111, y_screen + 65, x_screen - 81, y_screen + 191, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen - 36, y_screen + 150, sprite_color)
			draw_arrow(x_screen - 36, y_screen + 150, x_screen - 140, y_screen + 150, sprite_color)
		elseif x < 4100 then
			draw_box(x_screen - 159, y_screen + 65, x_screen - 129, y_screen + 191, sprite_color, COLOUR.detection_bg)
			draw_arrow(x_screen + 10, y_screen + 35, x_screen - 36, y_screen + 150, sprite_color)
			draw_arrow(x_screen - 36, y_screen + 150, x_screen - 66, y_screen + 150, sprite_color)
			draw_arrow(x_screen - 66, y_screen + 150, x_screen - 180, y_screen + 190, sprite_color)
		end
	end
	
    -- Draw boss HP right above it
	if sprite_type == "B0" then -- Caveman boss (Quarry 3)
		alert_text(x_screen + 55, y_screen + 115, fmt(" HP: %d ", boss_hp), COLOUR.text, COLOUR.warning_bg)				
	elseif  sprite_type == "B6" then -- Tiger boss (Jungle 4)
		alert_text(x_screen + 17, y_screen + 40, fmt(" HP: %d ", boss_hp), COLOUR.text, COLOUR.warning_bg)
	end
	
	-- Always draw Caveman boss defence hitboxes (region to deflect your stones or bowling balls), attack hitbox, and club "plataform" line
	if sprite_type == "B0" then
		local colour = "#00ffff77" -- cyan with transparency
		local animation = u8(WRAM.caveman_boss_animation)
		local misc_5_high = u8(WRAM.caveman_boss_misc_5_high)
		if animation >= 18 and animation <= 36 then -- defense hitboxes
			draw_box(x_screen, y_screen + 72, x_screen + 32, y_screen + 104, colour, COLOUR.detection_bg)
		elseif animation >= 42 and animation <= 72 or animation == 30 then
			draw_box(x_screen + 24, y_screen + 32, x_screen + 32, y_screen + 72, colour, COLOUR.detection_bg)
		elseif animation >= 78 and animation <= 102 then
			draw_box(x_screen, y_screen + 56, x_screen + 16, y_screen + 80, colour, COLOUR.detection_bg)
		end
		if animation == 36 then -- club "plataform" line
			draw_line(x_screen, y_screen + 80, x_screen + 64, y_screen + 80, 1, COLOUR.interaction)			
		end
		draw_box(x_screen + 8, y_screen + 32, x_screen + 48, y_screen + 104, COLOUR.warning_soft, COLOUR.detection_bg) -- attack hitbox
		
		-- Projectile trajectory
		if animation >= 78 and animation <= 102 and x_subspeed == 0 and x_speed == 0 then -- shooting animation, before shooting
			x_ref, y_ref = x_screen, y_screen
		end
		if animation >= 78 and animation <= 102 and x_ref ~= nil and misc_5_high < 5 then
			x_ref, y_ref = x_ref - 2, y_ref + 62
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 1
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 2
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 2
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 3
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 4
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 5
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 11, y_ref + 5
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref + 7
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 12, y_ref
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg) x_ref, y_ref = x_ref - 11, y_ref
			draw_box(x_ref, y_ref, x_ref + 8, y_ref + 8, COLOUR.warning_soft, COLOUR.detection_bg)
		end
	end
	
	-- Draw Boulder (rolling by itself) detection area
	if sprite_type == "C0" and misc3 == 0 then
		if Level_index == 0x07 then -- Volcanic 1
			draw_box(x_screen - 127, y_screen - 63, x_screen + 127, y_screen + 63, sprite_color, COLOUR.detection_bg)
		elseif Level_index == 0x0C then -- Machine 1
			draw_box(x_screen - 127, 0, x_screen + 127, 224, sprite_color, COLOUR.detection_bg)
		end
	end
	
	-- 	Draw Deadly Plant detection area (the sprite only checks Fred's x position)
	if sprite_type == "F2" or sprite_type == "F3" then -- F2 is standing still, F3 is attacking
		if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
			draw_box(x_screen - 63, 0, x_screen + 95, 224, sprite_color, COLOUR.detection_bg)
		end
	end
    
	if OPTIONS.display_sprite_info then
		---**********************************************
		-- Prints information next to the sprite

		if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
			Text_opacity = 0.8
		else
			Text_opacity = 0.5
		end
	
		draw_text(x_screen + 8, y_screen - 5, fmt("<%02d>", id/2), sprite_color, COLOUR.background, COLOUR.halo, true)
	
		-- Sprite position pixel and cross
		draw_pixel(x_screen, y_screen, sprite_color, COLOUR.background)
		if OPTIONS.display_debug_sprite_extra then
			gui.crosshair(x_screen, y_screen, 2, sprite_color)
		end
    
		---**********************************************
		-- The sprite table:
	
		if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
			Text_opacity = 0.8
		else
			Text_opacity = 0.5
		end
	
		-- Adjustment to fit the miscellaneous tables
		local misc_space = ""
		if OPTIONS.display_miscellaneous_sprite_table then
			for i = 1, OPTIONS.misc_counter do misc_space = misc_space .. "   " end
		end
	
		-- The table itself
		local sprite_str = fmt("<%02d> %s (%d.%02x, %d.%02x)%s", id/2, sprite_type, x, x_sub, y, y_sub, misc_space) 
		draw_text(Buffer_width + Border_right, table_position + counter*SNES9X_FONT_HEIGHT, sprite_str, sprite_color, true)
    
	end
	
    -- Miscellaneous sprite table
    if OPTIONS.display_miscellaneous_sprite_table then
        -- Font
        Font = false
        
        local t = OPTIONS.miscellaneous_sprite_table_number
        local misc, text = nil, ""
        for num = 1, 4 do
            misc = t[num] and u8(WRAM["sprite_miscellaneous" .. num] + id) or false
            text = misc and fmt("%s %2x", text, misc) or text
			text = string.upper(text)
        end
        
		draw_text(Buffer_width + Border_right, table_position + counter*SNES9X_FONT_HEIGHT, text, sprite_color, true)
    end
	
	---**********************************************
	-- Displays sprite hitbox
	
	local box_type = u8(0x06e0 + (id + 2)) -- TODO: list it correctly
	
	-- Adjust to erroneous hitboxes (via tests only) --draw_box(x_screen + , y_screen + , x_screen + , y_screen + , sprite_color)
	if sprite_type == "58" then box_type = 255 -- Sprite dying (various)
	elseif sprite_type == "7A" then box_type = 72 -- Smashing square stone
	elseif sprite_type == "9C" then box_type = 32 -- Big square stone
	elseif sprite_type == "C2" then box_type = 216 -- Surf board
	elseif sprite_type >= "C6" and sprite_type <= "C9" then box_type = 92 -- Bamm-Bamm/Pebbles
	elseif sprite_type == "F5" then box_type = 254 -- Plant that ejects Fred, it checks his interaction points with "plataform" sprites
	elseif sprite_type == "F7" then -- Tar creature
		box_type = 255 -- null
		if OPTIONS.display_sprite_hitbox then
			draw_box(x_screen + 8, y_screen + 11, x_screen + 40, y_screen + 44, sprite_color) -- custom because I didn't find a proper box type
		end
	end

	-- Reads offset info in the rom based of the hitbox type
	local rom1 = memory.readbyte(0x3b9d9 + box_type) -- $d9
	local rom2 = memory.readbyte(0x3b9dd + box_type) -- $dd
	local rom3 = memory.readbyte(0x3b9db + box_type) -- $d7
	local rom4 = memory.readbyte(0x3b9df + box_type) -- $db
	
	-- Print
	if OPTIONS.display_sprite_hitbox then
		draw_box(x_screen + rom1, y_screen + rom2, x_screen + rom3, y_screen + rom4, sprite_color)
	end
	
    local xoff, yoff = rom1, rom2 -- offset between the sprite position and the upper left corner of its hitbox
	local sprite_width, sprite_height = rom3 - rom1, rom4 - rom2
	
    -- Exporting some values
    Sprites_info[id].sprite_type = sprite_type
    Sprites_info[id].x, Sprites_info[id].y = x, y
    Sprites_info[id].x_screen, Sprites_info[id].y_screen = x_screen, y_screen
    Sprites_info[id].box_type = box_type
    Sprites_info[id].xoff, Sprites_info[id].yoff = xoff, yoff
    Sprites_info[id].width, Sprites_info[id].height = sprite_width, sprite_height
	
    return 1
end

local function sprites()
    
	OPTIONS.misc_counter = 0
	for i = 1, 4 do
		if OPTIONS.miscellaneous_sprite_table_number[i] then OPTIONS.misc_counter = OPTIONS.misc_counter + 1 end
	end
	
    local counter = 0
    local table_position = AR_y*32
    for id = 0, 2*FLINT.sprite_max - 1, 2 do
        counter = counter + sprite_info(id, counter, table_position)
    end
    
    -- Font
    Text_opacity = 0.7 -- Snes9x
    
	-- Adjustment to fit the miscellaneous tables index
	local misc_space = ""
	if OPTIONS.display_miscellaneous_sprite_table then
		misc_space = misc_space .. "     " 
		for i = 0, OPTIONS.misc_counter do misc_space = misc_space .. "   " end 
	end
	
	if OPTIONS.display_sprite_info then
		draw_text(Buffer_width + Border_right, table_position - SNES9X_FONT_HEIGHT, fmt("Sprites: %.2d %s", counter, misc_space), COLOUR.weak, true)
	else
        draw_text(Buffer_width + Border_right, table_position - SNES9X_FONT_HEIGHT, "Sprite info: off", COLOUR.weak2, true)	
	end
	
    -- Miscellaneous sprite table: index
    if OPTIONS.display_miscellaneous_sprite_table then
        Font = false
        
        local t = OPTIONS.miscellaneous_sprite_table_number
        local text = "Misc"
        for num = 1, 4 do
            text = t[num] and fmt("%s %2d", text, num) or text
        end
        
        draw_text(Buffer_width + Border_right, table_position - SNES9X_FONT_HEIGHT, text, info_color, true)
    end
	
	--for id = 0, 2*FLINT.sprite_max - 1, 2 do --REMOVE
		--Drag and drop sprites with the mouse 
		--if Cheat.is_dragging_sprite then
			--Cheat.drag_sprite(id)
			--Cheat.is_cheating = true
		--end
	--end
	sprite_routines_executed = true
end


local function show_counters()
    if not OPTIONS.display_counters then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    local text_counter = 0
    
	local invincibility_timer = u8(WRAM.invincibility_timer)
	local idle_timer = u16(WRAM.idle_timer)
    
    local display_counter = function(label, value, default, mult, frame, color)
        if value == default then return end
        text_counter = text_counter + 1
        local color = color or COLOUR.text
        
        draw_text(0, AR_y*88 + (text_counter * height), fmt("%s: %d", label, (value * mult) - frame), color)
    end
    
    display_counter("Invincibility", invincibility_timer, 0, 1, 0, COLOUR.positive)
	display_counter("Idle timer", idle_timer, 300, 1, 0, COLOUR.warning_soft)
end


-- Main function to run inside a level
local function level_mode()
    if Game_mode == FLINT.game_mode_level then
	
		draw_tilesets(Camera_x, Camera_y)
        
        level_info()
    
        sprites()
        
        extended_sprites()
        
        player()
        
        show_counters()
        
        -- Draws/Erases the hitbox for objects --TODO
        if true or User_input.mouse_inwindow == 1 then
            select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        end
        
    end
end


local function left_click()
    for _, field in pairs(Script_buttons) do
        
        -- if mouse is over the button
        if mouse_onregion(field.x, field.y, field.x + field.width, field.y + field.height) then
                field.action()
                return
        end
    end
    
    -- Drag and drop sprites --TODO
    if Cheat.allow_cheats then
        local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        if type(id) == "number" and id >= 0 and id < 2*FLINT.sprite_max - 1 then
            Cheat.dragging_sprite_id = id
            Cheat.is_dragging_sprite = true
            return
        end
    end
    
    if not Options_menu.show_menu then
        select_tile()
    end
end


-- This function runs at the end of paint callback
-- Specific for info that changes if the emulator is paused and idle callback is called
local function snes9x_buttons() 
    -- Font
    Text_opacity = 1.0
	local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT + 4
	
    if not Options_menu.show_menu and User_input.mouse_inwindow == 1 then
        create_button(100, -Border_top, " Menu ", function() Options_menu.show_menu = true end) -- Snes9x
        
        create_button(-Border_left, Buffer_height - Border_bottom, Cheat.allow_cheats and "Cheats: allowed" or "Cheats: blocked",
            function() Cheat.allow_cheats = not Cheat.allow_cheats end, {always_on_client = true, ref_y = 1.0})
        ;
        
        create_button(Buffer_width + Border_right, Buffer_height + Border_bottom, "Erase Tiles",
            function() Tiletable = {} end, {always_on_client = true, ref_y = 1.0})
        ;
		
		-- Some cheat buttons
		if Cheat.allow_cheats and Game_mode == FLINT.game_mode_level then
			local y = 216
			-- Lives cheat
			create_button(75, y, " - ", function() Cheat.change_address(WRAM.lives, -1) end)
			create_button(88, y, " + ", function() Cheat.change_address(WRAM.lives, 1) end)
			-- Bowling balls cheat
			create_button(115, y, " - ", function() Cheat.change_address(WRAM.bowling_balls, -1) end)
			create_button(128, y, " + ", function() Cheat.change_address(WRAM.bowling_balls, 1) end)
			-- Stones cheat
			create_button(155, y, " - ", function() Cheat.change_address(WRAM.stones, -1) end)
			create_button(168, y, " + ", function() Cheat.change_address(WRAM.stones, 1) end)
			-- Time cheat
			create_button(215, 24, " - ", function() Cheat.change_address(WRAM.timer, -1) end)
			create_button(228, 24, " + ", function() Cheat.change_address(WRAM.timer, 1) end)
			
			-- Passwords cheat
			create_button(-Border_left, Buffer_height - Border_bottom - 18, OPTIONS.stage_skip and "Stage Skip:ON" or "Stage Skip:OFF",
            function() OPTIONS.stage_skip = not OPTIONS.stage_skip end, {always_on_client = true, ref_y = 1.0})
			
			create_button(-Border_left, Buffer_height - Border_bottom - 9, OPTIONS.invincibility and "Invincibility:ON" or "Invincibility:OFF",
            function() OPTIONS.invincibility = not OPTIONS.invincibility end, {always_on_client = true, ref_y = 1.0})	

			-- Auto-pilot cheat
			if Level_index == 2 then	
				create_button(100, 25, OPTIONS.auto_pilot and " Auto-pilot:ON " or " Auto-pilot:OFF ",
				function() OPTIONS.auto_pilot = not OPTIONS.auto_pilot end, {always_on_client = true, ref_y = 1.0})
			end
		end
		
		-- Compact Memory Edit -- TODO
		if Memory.allow_edit then
			local x_pos, y_pos = -Border_left, 189
			
			local value_dec_shown = fmt("%03d", u8(OPTIONS.address))
			local width, height = 14, SNES9X_FONT_HEIGHT		
			draw_rectangle(x_pos, y_pos - 1, width + 4, height, COLOUR.text)--, COLOUR.background)
			gui.text(x_pos + delta_x, y_pos, value_dec_shown, COLOUR.memory)
			
			x_pos = -Border_left + 20
			create_button(x_pos, y_pos - 1, "-", function() OPTIONS.value = OPTIONS.value - 1
			if OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 256 end end)
            create_button(x_pos + delta_x + 1, y_pos - 1, "+", function() OPTIONS.value = OPTIONS.value + 1
			if OPTIONS.value > 255 then OPTIONS.value = OPTIONS.value - 256 end end)
			create_button(x_pos + 2*delta_x + 2, y_pos - 1, "-10", function() OPTIONS.value = OPTIONS.value - 0x10
			if OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 256 end end)
            create_button(x_pos + 5*delta_x + 3, y_pos - 1, "+10", function() OPTIONS.value = OPTIONS.value + 0x10
			if OPTIONS.value > 255 then OPTIONS.value = OPTIONS.value - 256 end end)
		end
    else
        if Cheat.allow_cheats then  -- show cheat status anyway
            Text_opacity = 0.8
            draw_text(-Border_left, Buffer_height + Border_bottom, "Cheats: allowed", COLOUR.warning, true, false, 0, 1)
        end
		if Level_index == 2 and OPTIONS.auto_pilot then
			alert_text(101, 18, " Auto-pilot:ON ", COLOUR.memory, COLOUR.warning_bg)
		end
    end
    
    -- Drag and drop sprites with the mouse --TODO
    --if sprite_routines_executed and Cheat.is_dragging_sprite then
        --Cheat.drag_sprite(Cheat.dragging_sprite_id)
        --Cheat.is_cheating = true
    --end
    
    Options_menu.display()
end


--#############################################################################
-- CHEATS

-- This signals that some cheat is activated, or was some short time ago
Cheat.allow_cheats = true
Cheat.is_cheating = false
function Cheat.is_cheat_active()
    if Cheat.is_cheating then
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 0, " Cheat ", COLOUR.warning,COLOUR.warning_bg)
        Previous.is_cheating = true
    else
        if Previous.is_cheating then
            emu.message("Script applied cheat")
            Previous.is_cheating = false
        end
    end
end


-- This function make Fred's position free
-- Press L+R+up to activate and L+R+down to turn it off.
-- While active, press directionals to fly free and A or X to boost him up
Cheat.under_free_move = false
function Cheat.free_movement()
	if Game_mode ~= FLINT.game_mode_level then return end
	
	-- Enable/Disable
    if (Joypad["L"] == 1 and Joypad["R"] == 1 and Joypad["up"] == 1) then Cheat.under_free_move = true end
    if (Joypad["L"] == 1 and Joypad["R"] == 1 and Joypad["down"] == 1) then Cheat.under_free_move = false end
    
	if not Cheat.under_free_move then return end
    
    local x_pos, y_pos = u16(WRAM.x), u16(WRAM.y)
	local on_ground = u8(WRAM.on_ground)
    local pixels = (Joypad["A"] == 1 and 16) or (Joypad["X"] == 1 and 3) or 1  -- how many pixels per frame
    
	-- Math
    if Joypad["left"] == 1 then x_pos = x_pos - pixels end
    if Joypad["right"] == 1 then x_pos = x_pos + pixels end
    if Joypad["up"] == 1 then y_pos = y_pos - pixels end
    if Joypad["down"] == 1 then	y_pos = y_pos + pixels end
    
	-- Disable normal button behavior
	if Joypad["down"] == 1 then pad_send[1].down = false end -- avoid ducking
	if Joypad["X"] == 1 then pad_send[1].X = false end -- avoid throwing stone
	if Joypad["B"] == 1 then pad_send[1].B = false end -- avoid throwing bowling ball
	--if Joypad["Y"] == 1 then pad_send[1].Y = false end -- avoid smashing
	joypad.set(1, pad_send[1]) -- set
	
    -- Manipulate some values
    w16(WRAM.x, x_pos)
    w16(WRAM.y, y_pos)
	w16(WRAM.x_subspeed, 0)     --\ w16 to set 0 both speed and subspeed
    w16(WRAM.y_subspeed, -0x30) --/ -0x30 to compensate the falling of 30 subpixels/frame even with y speed = 0
	w8(WRAM.on_ground, 0) -- to takeoff the ground
    --w8(WRAM.invincibility_timer, 120) -- to not take damage
    
    Cheat.is_cheating = true
    Previous.under_free_move = true
end


-- Drag and drop sprites with the mouse, if the cheats are activated and mouse is over the sprite
-- Right clicking and holding: drags the sprite
-- Releasing: drops it over the latest spot
function Cheat.drag_sprite(id) --TODO
    if Game_mode ~= FLINT.game_mode_level then Cheat.is_dragging_sprite = false ; return end
	if not sprite_routines_executed then return end -- to avoid getting here without writing the Sprites_info[id] table
	draw_text(50, 150, "TEST") -- REMOVE
	draw_text(100, 150, fmt("xoff:(%d)", Sprites_info[id].xoff))
    
    local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
    local xgame, ygame = game_coordinates(User_input.xmouse - xoff, User_input.ymouse - yoff, Camera_x, Camera_y)
    
    local sprite_xhigh = floor(xgame/256)
    local sprite_xlow = xgame - 256*sprite_xhigh
    local sprite_yhigh = floor(ygame/256)
    local sprite_ylow = ygame - 256*sprite_yhigh
    
	draw_text(100, 130, fmt("(%d, %d)", x_game, y_game)) -- REMOVE
	
    --w8(WRAM.sprite_x + 1 + id, sprite_xhigh)
    --w8(WRAM.sprite_x + id, sprite_xlow)
    w16(WRAM.sprite_x + id, xgame)
    --w8(WRAM.sprite_y + 1 + id, sprite_yhigh)
    --w8(WRAM.sprite_y + id, sprite_ylow)
    w16(WRAM.sprite_y + id, ygame)
end


function Cheat.passwords()
	-- Stage Skip
	if OPTIONS.stage_skip then
		w8(WRAM.stage_skip, 1)
	else
		w8(WRAM.stage_skip, 0)
	end
	if not Cheat.allow_cheats then
		w8(WRAM.stage_skip, 0)
	end
	
	-- Invincibility
	if OPTIONS.invincibility then
		w8(WRAM.invincibility, 1)
	else
		w8(WRAM.invincibility, 0)	
	end
	if not Cheat.allow_cheats then
		w8(WRAM.invincibility, 0)
	end
end


-- Auto-pilot cheat to be used in Bedrock
function Cheat.auto_pilot()
	if not Cheat.allow_cheats then return end
	if not OPTIONS.auto_pilot then return end
	if Level_index ~= 2 then return end -- Bedrock only
	
	local x, y = s16(WRAM.x), s16(WRAM.y)
	local bamm_bamm_x, bamm_bamm_y = s16(0x09C2), s16(0x0A06) -- sprite on slot 28
	local pebbles_x, pebbles_y = s16(0x09C0), s16(0x0A04) -- sprite on slot 27
	local current_child_x
	local offset = 0 -- it can be any value next to zero
	
	if x < 1700 then -- section 1
		current_child_x = bamm_bamm_x
	elseif x >= 1700 and x < 2700 then -- section 2
		if bamm_bamm_y > pebbles_y then current_child_x = bamm_bamm_x else current_child_x = pebbles_x end
	elseif x >= 2700 and x < 3400 then -- section 3
		current_child_x = bamm_bamm_x
	elseif x >= 3400 and x < 4500 then -- section 4
		if bamm_bamm_y > pebbles_y then current_child_x = bamm_bamm_x else current_child_x = pebbles_x end
		if x >= 3706 then current_child_x = bamm_bamm_x end -- correction for that tight part
	elseif x >= 4500 and x < 6200 then -- section 5
		current_child_x = pebbles_x
	else -- section 6 (end)
		if bamm_bamm_y > pebbles_y then current_child_x = bamm_bamm_x else current_child_x = pebbles_x end
	end
	
	if x <= current_child_x + offset then
		pad_send[1].right = true
		joypad.set(1, pad_send[1])
	elseif x > current_child_x + offset then
		pad_send[1].left = true
		joypad.set(1, pad_send[1])
	end
end


-- Snes9x: modifies address <address> value from <current> to <current + modification>
-- [size] is the optional size in bytes of the address
-- TODO: [is_signed] is untrue if the value is unsigned, true otherwise
function Cheat.change_address(address, modification, size)
    size = size or 1
    local memoryf_read =  (size == 1 and u8) or (size == 2 and u16) or (size == 3 and u24) or error"size is too big"
    local memoryf_write = (size == 1 and w8) or (size == 2 and w16) or (size == 3 and w24) or error"size is too big"
    local max_value = 256^size - 1
    local current = memoryf_read(address)
    --if is_signed then max_value = signed(max_value, 8*size) end
    
    local new = (current + modification)%(max_value + 1)
    memoryf_write(address, new)	
    Cheat.is_cheating = true
end


--#############################################################################
-- MEMORY EDIT --

function Memory.edit()
	if not Memory.allow_edit then return end
	if not apply then return end

	if OPTIONS.edit_method == "Freeze" then
		poked = false
	else
		apply = false
	end
	
	local slot = OPTIONS.edit_sprite_table_number
	if not poked then
		if OPTIONS.edit_sprite_table then
			for i = 1, FLINT.sprite_max + FLINT.extended_sprite_max do
				if slot[i] then
					if OPTIONS.size == 2 then
						memory.writeword(OPTIONS.address + 2*(i - 1), OPTIONS.value)
					else
						memory.writebyte(OPTIONS.address + 2*(i - 1), OPTIONS.value)
					end
			
					if OPTIONS.edit_method == "Poke" then
						emu.message("\n         Applied address poke")
					else
						alert_text(Buffer_middle_x - 12*SNES9X_FONT_WIDTH, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)
					end
			
					poked = true
				end
			end
		else
			if OPTIONS.size == 2 then
				memory.writeword(OPTIONS.address, OPTIONS.value)
			else
				memory.writebyte(OPTIONS.address, OPTIONS.value)
			end
		
			if OPTIONS.edit_method == "Poke" then
				emu.message("\n         Applied address poke")
			else
				alert_text(Buffer_middle_x - 12*SNES9X_FONT_WIDTH, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)
			end
		
			poked = true
		end
	end
end

--#############################################################################
-- MAIN --


-- Key presses:
Keys.registerkeypress("rightclick", right_click)
Keys.registerkeypress("leftclick", left_click)
Keys.registerkeypress(OPTIONS.hotkey_increase_opacity, increase_opacity)
Keys.registerkeypress(OPTIONS.hotkey_decrease_opacity, decrease_opacity)

-- Key releases:
Keys.registerkeyrelease("mouse_inwindow", function() Cheat.is_dragging_sprite = false end)
Keys.registerkeyrelease("leftclick", function() Cheat.is_dragging_sprite = false end)


gui.register(function()
    -- Initial values, don't make drawings here
    snes9x_status()
    Script_buttons = {}  -- reset the buttons
    
    -- Dark filter to cover the game area
    if Filter_opacity ~= 0 then
        gui.opacity(Filter_opacity/10)
        gui.box(0, 0, Buffer_width, Buffer_height, Filter_color)
        gui.opacity(1.0)
    end
    
    -- Drawings are allowed now
    scan_flintstones()
    
    level_mode()
    
    show_movie_info()
    show_misc_info()
    show_controller_data()
    
    Cheat.is_cheat_active()
    
    snes9x_buttons()
	
	show_mouse_info()
	
	--
	if Options_menu.current_tab == "Memory edit" then -- REMOVE
		gui.text(180, 192, string.format("poked = %s", tostring(poked)), COLOUR.warning)
		gui.text(180, 200, string.format("apply = %s", tostring(apply)), COLOUR.warning)
		gui.text(170, 208, string.format(".edit_method = %s", tostring(OPTIONS.edit_method)), COLOUR.warning)
	end
end)


emu.registerbefore(function()
    get_joypad()
	scanInputDevs()
	scanJoypad()
	sendJoypad()
    
    if Cheat.allow_cheats then
        Cheat.is_cheating = false
        
        Cheat.free_movement()
    else
        -- Cancel any continuous cheat
        Cheat.under_free_move = false
        
        Cheat.is_cheating = false
    end
	
	Cheat.passwords()
	
	Cheat.auto_pilot()
	
	Memory.edit()
end)


emu.registerexit(function()
    INI.save_options()
end)


print("Lua script loaded successfully.")


while true do
    -- User input data
    Previous.User_input = copytable(User_input)
    local tmp = input.get()
    for entry, value in pairs(User_input) do
        User_input[entry] = tmp[entry] or false
    end
    User_input.mouse_inwindow = mouse_onregion(0, 0, Buffer_width - 1, Buffer_height - 1) and 1 or 0 -- Snes9x, custom field
	
    -- Detect if a key was just pressed or released
    for entry, value in pairs(User_input) do
        if (value ~= false) and (Previous.User_input[entry] == false) then Keys.pressed[entry] = true
            else Keys.pressed[entry] = false
        end
        if (value == false) and (Previous.User_input[entry] ~= false) then Keys.released[entry] = true
            else Keys.released[entry] = false
        end
    end
    
    -- Key presses/releases execution:
    for entry, value in pairs(Keys.press) do
        if Keys.pressed[entry] then
            value()
        end
    end
    for entry, value in pairs(Keys.release) do
        if Keys.released[entry] then
            value()
        end
    end
    
    -- Lag-flag is accounted correctly only inside this loop
    Is_lagged = emu.lagged()
    
    emu.frameadvance()
end
