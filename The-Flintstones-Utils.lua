-----------------------------------------------------------------------------------
--  The Flintstones (U) Utility Script for Lsnes - rr2 version
--  http://tasvideos.org/GameResources/SNES/Flintstones.html
--  
--  Author: BrunoValads 
--  Git repository: https://github.com/brunovalads/the-flintstones-snes
--
--  Based on Amaraticando's generic script for Lsnes
--  https://github.com/rodamaral/amaraticando-tas/blob/master/Tools/lsnes/lsnes.lua
-----------------------------------------------------------------------------------

--#############################################################################
-- CONFIG:

local OPTIONS = {
    -- Hotkeys  (look at the manual to see all the valid keynames)
    -- make sure that the hotkeys below don't conflict with previous bindings
    hotkey_increase_opacity = "equals",  -- to increase the opacity of the text: the '='/'+' key 
    hotkey_decrease_opacity = "minus",   -- to decrease the opacity of the text: the '_'/'-' key
    
    -- Script settings
    use_custom_fonts = true,
    display_all_controllers = true,
    
    -- Lateral gaps (initial values)
    left_gap = 40*8 + 2,
    right_gap = 205, --32
    top_gap = 20,
    bottom_gap = 8,
}

-- Colour settings
local COLOUR = {
    transparency = -1,
    
    -- Text
    default_text_opacity = 1.0,
    default_bg_opacity = 0.4,
    text = 0xffffff,
    background = 0x000000,
    halo = 0x000040,
	positive = 0x00ff00,
    warning = 0x00ff0000,
    warning_bg = 0x000000ff,
    warning2 = 0xff00ff,
    weak = 0x00a9a9a9,
    very_weak = 0xa0ffffff,
	sprites = {
        0x80ffff, -- cyan
        0xa0a0ff, -- blue
        0xff6060, -- red
        0xff80ff, -- magenta
        0xffa100, -- orange
        0xffff80, -- yellow
		0x40ff40  -- green
	},
	extsprites = {
        0xff3700, -- orange to red gradient 6
		0xff5b00, -- orange to red gradient 4
		0xff8000, -- orange to red gradient 2
		0xffa500 -- orange to red gradient 0 (orange)
    }
}

-- EDIT???
LSNES = {}
draw = {}

-- Font settings
LSNES.FONT_HEIGHT = 16
LSNES.FONT_WIDTH = 8
CUSTOM_FONTS = {
        [false] = { file = nil, height = LSNES.FONT_HEIGHT, width = LSNES.FONT_WIDTH }, -- this is lsnes default font
        
        snes9xlua =       { file = [[data/snes9xlua.font]],        height = 16, width = 10 },
        snes9xluaclever = { file = [[data/snes9xluaclever.font]],  height = 16, width = 08 }, -- quite pixelated
        snes9xluasmall =  { file = [[data/snes9xluasmall.font]],   height = 09, width = 05 },
        snes9xtext =      { file = [[data/snes9xtext.font]],       height = 11, width = 08 },
        verysmall =       { file = [[data/verysmall.font]],        height = 08, width = 04 }, -- broken, unless for numerals
}

-- Bitmap strings (base64 encoded)
local BMP_STRINGS = {}
BMP_STRINGS.stone_animation = {}
BMP_STRINGS.stone_animation[1] = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABkSURBVChTbY7BCcAwDAM9Rr4do2t0hayUmbJOR1ArwxmSNiBs5ENKSFo0zqarhTzx6vi+PM5+pO7RVwjAE8CyVxAVhtgBE7KBSQrJgJlECqbTLP6XEJV/wAfaAW4FWa7dAUnxAI4rvU4zOLOwAAAAAElFTkSuQmCC"
BMP_STRINGS.stone_animation[2] = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABgSURBVChTZY1BDcAwDAMDo9/BGI1RKKViKp1B8HSunM8erhL7nJYk6xkltO6hqjPjd4C559VqgAZ613QA+LtAGIidGdgAQ4A0szMbIIhBGMAlzgDFAMo3/oInEM3sR6oPOgiH3EzDH1oAAAAASUVORK5CYII="
BMP_STRINGS.stone_animation[3] = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABmSURBVChTbY1REcAgDEMrg9/JmI1ZwBKasDMJZa+3FLjjIxtNXhtz91Svl6OnME7/CLS7hBJSiAjeVkNHSNsC7StRrWlrhQk1845zqsAI87/CQlzigyGQQBD/hBDAWidggxRqnnIbxeO8M4qNT0QAAAAASUVORK5CYII="
BMP_STRINGS.stone_animation[4] = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABhSURBVChTZY1LDcAwDEMDo9fBGI1RKKViKp1B8PIyOZq0g5uPX9yQ1LrXFNrzyPHd1bPOoWtEiR4ZKhP50lDkLXMBNMhfoAaJwfwmuQIVUE1GUp3kgwZsUA3/EjBtsJcUD4ILi9Qg/s7KAAAAAElFTkSuQmCC"
BMP_STRINGS.stone_animation[5] = "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABqSURBVChTXY5RFcAgDAMrg9/JmI1ZwBKaZmcSOo4tpfCR90pyTTF3D13FvJ2lj9NDMRBKT6s9wU4QDWoB2BUQm2rifddjQmrABBzmv4A3/HwGQ/MC5XNqAkC84+MCFTIjZQEhhYgzn+/2AnfrtbTjEEkYAAAAAElFTkSuQmCC"
BMP_STRINGS.stone_animation[6] = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABeSURBVChTTY1BDcAwDAMDo9/BGI1RKKViGp1B8HaRrtrDjeKc3UrSWucIuka19DdwzyOqPluokywebGLH39UYz5ptMjegoQRRfwFAA4ZNphswwQTgYGsDPMjkvz5JvfAkkmOVNQjjAAAAAElFTkSuQmCC"
BMP_STRINGS.stone_animation[7] = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuNvyMY98AAABeSURBVChTTY7REcAgDEIzhr8do2u4gis5U9fpCFToPc8POBIIWpKC3koGMwg949K8W3CaRsjGO0dQa4V2YwIeaHDAjTGXTj2XPLVNAlygqc8fzgWaYAImgxCBv0H1AS8+ksPrW9AXAAAAAElFTkSuQmCC"

-- Others
local Y_CAMERA_OFF = 1  -- small adjustment for screen coordinates <-> object position conversion
local INPUT_RAW_VALUE = "value"  -- name of the inner field in input.raw() for values


-- END OF CONFIG < < < < < < <
--#############################################################################
-- INITIAL STATEMENTS:


-- Load environment
local bit, gui, input, movie, memory, memory2 = bit, gui, input, movie, memory, memory2
local string, math, table, next, ipairs, pairs, io, os, type = string, math, table, next, ipairs, pairs, io, os, type

-- Script verifies whether the emulator is indeed Lsnes - rr2 version / beta23 or higher
if not lsnes_features or not lsnes_features("text-halos") then
    error("This script works in a newer version of lsnes.")
end

-- Text/draw.Bg_global_opacity is only changed by the player using the hotkeys
-- Text/Bg_opacity must be used locally inside the functions
draw.Text_global_opacity = COLOUR.default_text_opacity
draw.Bg_global_opacity = COLOUR.default_bg_opacity
draw.Text_local_opacity = 1
draw.Bg_local_opacity = 1

-- Verify whether the fonts exist and create the custom fonts' drawing function
draw.font = {}
for font_name, value in pairs(CUSTOM_FONTS) do
    if value.file and not io.open(value.file) then
        print("WARNING:", string.format("./%s is missing.", value.file))
        CUSTOM_FONTS[font_name] = nil
    else
        draw.font[font_name] = font_name and gui.font.load(value.file) or gui.text
    end
end

local fmt = string.format

-- Compatibility of the memory read/write functions
local u8  = function(address, value) if value then memory2.WRAM:byte(address, value) else
    return memory.readbyte("WRAM", address) end
end
local s8  = function(address, value) if value then memory2.WRAM:sbyte(address, value) else
    return memory.readsbyte("WRAM", address) end
end
local u16  = function(address, value) if value then memory2.WRAM:word(address, value) else
    return memory.readword("WRAM", address) end
end
local s16  = function(address, value) if value then memory2.WRAM:sword(address, value) else
    return memory.readsword("WRAM", address) end
end
local u24  = function(address, value) if value then memory2.WRAM:hword(address, value) else
    return memory.readhword("WRAM", address) end
end
local s24  = function(address, value) if value then memory2.WRAM:shword(address, value) else
    return memory.readshword("WRAM", address) end
end

-- Bitmaps and dbitmaps
local BITMAPS = {}
BITMAPS.stone_animation = {}
for k = 1, 7 do
	BITMAPS.stone_animation[k] = gui.image.load_png_str(BMP_STRINGS.stone_animation[k])
	--BITMAPS.stone_animation[k]:adjust_transparency(200)
end
BMP_STRINGS = nil  -- bitmap-strings shall not be used past here

--#############################################################################
-- GAME SPECIFIC RESOURCES:

FLINT = {
    sprite_max = 29,
	extended_sprite_max = 3 -- ??? shouldn't be 4?
}

WRAM = {
    -- General
    game_mode = 0x003C,
	level = 0x1D5B,
	timer = 0x1D8D, -- 2 bytes
    
	-- Camera
	camera_x = 0x0018, -- 2 bytes
	camera_y = 0x001A, -- 2 bytes
	
    -- Fred
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
	score = 0x1D75, -- 2 bytes
	throw_power = 0x1DD5, -- 2 bytes (but only the first is used)
	idle_timer = 0x1DD7, -- 2 bytes
	
    -- Sprites
    sprite_status = 0x0946,
	sprite_x = 0x098A, -- 2 bytes
	sprite_y = 0x09CE, -- 2 bytes
	sprite_x_sub = 0x0A13,
	sprite_y_sub = 0x0A57,
	sprite_x_speed = 0x0D86,
	sprite_x_subspeed = 0x0D87,
	sprite_y_speed = 0x0DCA,
	sprite_y_subspeed = 0x0DCB,
	boss_hp = 0x1ED6,
	
    -- Extended sprites
    extsprite_status = 0x0980,
	extsprite_x = 0x09C4, -- 2 bytes
	extsprite_y = 0x0A08, -- 2 bytes
	extsprite_x_sub = 0x0A4D,
	extsprite_y_sub = 0x0A91,
	extsprite_x_speed = 0x0DC0,
	extsprite_x_subspeed = 0x0DC1,
	extsprite_y_speed = 0x0E04,
	extsprite_y_subspeed = 0x0E05,
	
    -- Passwords
	stage_skip = 0x0622,
	invincibility = 0x0624
}
local WRAM = WRAM

--#############################################################################
-- SCRIPT UTILITIES:


-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}
local User_input = {}


-- unsigned to signed (based in <bits> bits)
local function signed(num, bits)
    local maxval = 1<<(bits - 1)
    if num < maxval then return num else return num - 2*maxval end
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


local function mouse_onregion(x1, y1, x2, y2)
    -- Reads external mouse coordinates
    local mouse_x = User_input.mouse_x
    local mouse_y = User_input.mouse_y
    
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


-- Those 'Keys functions' register presses and releases. Pretty much a copy from the script of player Fat Rat Knight (FRK)
-- http://tasvideos.org/userfiles/info/5481697172299767
Keys = {}
Keys.KeyPress=   {}
Keys.KeyRelease= {}

function Keys.registerkeypress(key,fn)
-- key - string. Which key do you wish to bind?
-- fn  - function. To execute on key press. False or nil removes it.
-- Return value: The old function previously assigned to the key.

    local OldFn= Keys.KeyPress[key]
    Keys.KeyPress[key]= fn
    --Keys.KeyPress[key]= Keys.KeyPress[key] or {}
    --table.insert(Keys.KeyPress[key], fn)
    input.keyhook(key,type(fn or Keys.KeyRelease[key]) == "function")
    return OldFn
end


function Keys.registerkeyrelease(key,fn)
-- key - string. Which key do you wish to bind?
-- fn  - function. To execute on key release. False or nil removes it.
-- Return value: The old function previously assigned to the key.

    local OldFn= Keys.KeyRelease[key]
    Keys.KeyRelease[key]= fn
    input.keyhook(key,type(fn or Keys.KeyPress[key]) == "function")
    return OldFn
end


function Keys.altkeyhook(s,t)
-- s,t - input expected is identical to on_keyhook input. Also passed along.
-- You may set by this line: on_keyhook = Keys.altkeyhook
-- Only handles keyboard input. If you need to handle other inputs, you may
-- need to have your own on_keyhook function to handle that, but you can still
-- call this when generic keyboard handling is desired.

    if     Keys.KeyPress[s]   and (t[INPUT_RAW_VALUE] == 1) then
        Keys.KeyPress[s](s,t)
    elseif Keys.KeyRelease[s] and (t[INPUT_RAW_VALUE] == 0) then
        Keys.KeyRelease[s](s,t)
    end
end

-- A copy from gocha's SMW script
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

-- scan button presses
function scanJoypad()
    for i = 1, pad_max do
        pad_prev[i] = copytable(pad_press[i])
        pad_press[i] = input.joyget(i)
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
-- scan keyboard/mouse input
function scanInputDevs()
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
-- send button presses
function sendJoypad()
    for i = 1, pad_max do
        joypad.set(i, pad_send[i])
    end
end
-- end of copy

local function get_last_frame(advance)
    local cf = movie.currentframe() - (advance and 0 or 1)
    if cf == -1 then print"NEGATIVE FRAME!!!!!!!!!!!" cf = 0 end
    
    return cf
end


-- Stores the raw input in a table for later use. Should be called at the start of paint and timer callbacks
local function read_raw_input()
    for key, inner in pairs(input.raw()) do
        User_input[key] = inner[INPUT_RAW_VALUE]
    end
    User_input.mouse_x = math.floor(User_input.mouse_x)
    User_input.mouse_y = math.floor(User_input.mouse_y)
end


-- Extensions to the "gui" function, to handle fonts and opacity
draw.Font_name = false


function draw.opacity(text, bg)
    draw.Text_local_opacity = text or draw.Text_local_opacity
    draw.Bg_local_opacity = bg or draw.Bg_local_opacity
    
    return draw.Text_local_opacity, draw.Bg_local_opacity
end


function draw.font_width(font)
    font = font or Font
    return CUSTOM_FONTS[font] and CUSTOM_FONTS[font].width or LSNES.FONT_WIDTH
end


function draw.font_height(font)
    font = font or Font
    return CUSTOM_FONTS[font] and CUSTOM_FONTS[font].height or LSNES.FONT_HEIGHT
end


function LSNES.get_emu_status()
    LSNES.Runmode = gui.get_runmode()
    LSNES.Lsnes_speed = settings.get_speed()
    
end

function LSNES.get_rom_info()
    local ROM_info = {}
    
    ROM_info.is_loaded = movie.rom_loaded()
    if ROM_info.is_loaded then
        -- ROM info
        local movie_info = movie.get_rom_info()
        ROM_info.slots = #movie_info
        ROM_info.hint = movie_info[1].hint
        ROM_info.hash = movie_info[1].sha256
        
        -- Game info
        local game_info = movie.get_game_info()
        ROM_info.game_type = game_info.gametype
        ROM_info.game_fps = game_info.fps
    else
        -- ROM info
        ROM_info.slots = 0
        ROM_info.hint = false
        ROM_info.hash = false
        
        -- Game info
        ROM_info.game_type = false
        ROM_info.game_fps = false
    end
    
    return ROM_info
end

function LSNES.get_controller_info()
    local info = {}
    
    info.ports = {}
    info.num_ports = 0
    info.total_buttons = 0
    info.total_controllers = 0
    
    for port = 0, math.huge do
        info.ports[port] = input.port_type(port)
        if not info.ports[port] then break end
        info.num_ports = info.num_ports + 1
    end
    
    for lcid = 0, math.huge do
        local port, controller = input.lcid_to_pcid2(lcid)
        local ci = (port and controller) and input.controller_info(port, controller) or nil
        local symbols = {}
        
        if ci then
            info[lcid] = {port = port, controller = controller}
            info[lcid].type = ci.type
            info[lcid].class = ci.class
            info[lcid].classnum = ci.classnum
            info[lcid].button_count = ci.button_count
            info[lcid].symbols = {}
            for button, inner in ipairs(ci.buttons) do
                info[lcid].symbols[button] = inner.symbol
                --print(button, inner.symbol)
            end
            
            -- Some
            info.total_buttons = info.total_buttons + ci.button_count
            info.total_controllers = info.total_controllers + 1
            
        elseif lcid > 0 then
            break
        end
    end
    
    --[[
    for a,b in pairs(info) do
        print(a,b)
    end
    --]]
	
	get_joypad()
	
    return info
end

function LSNES.get_movie_info()
    LSNES.movie = LSNES.movie or {}
    local info = LSNES.movie
    
    local pollcounter = movie.pollcounter(0, 0, 0)
    LSNES.frame_boundary = LSNES.frame_boundary or (pollcounter ~= 0 and "polling" or "start")
    
    info.Readonly = movie.readonly()
    info.Framecount = movie.framecount()
    info.Subframecount = movie.get_size()
    info.Lagcount = movie.lagcount()
    info.Rerecords = movie.rerecords()
    
    -- Last frame info
    info.Lastframe_emulated = movie.currentframe() - (LSNES.frame_boundary == "start" and 1 or 0)
    if info.Lastframe_emulated < 0 then info.Lastframe_emulated = 0 end
    info.Size_last_frame = LSNES.size_frame(info.Lastframe_emulated)
    if info.Lastframe_emulated <= 0 then
        info.Starting_subframe_last_frame = 0
    elseif info.Lastframe_emulated <= info.Framecount then
        info.Starting_subframe_last_frame = movie.current_first_subframe() + 1
        if LSNES.frame_boundary == "start" then
            info.Starting_subframe_last_frame = info.Starting_subframe_last_frame - info.Size_last_frame
        end
    else
        info.Starting_subframe_last_frame = info.Subframecount + (info.Lastframe_emulated - info.Framecount)
    end
    info.Final_subframe_last_frame = info.Starting_subframe_last_frame + info.Size_last_frame - 1  -- unused
    
    -- Current frame info
    info.internal_subframe = (LSNES.frame_boundary == "start" or LSNES.frame_boundary == "end") and 1 or pollcounter + 1
    info.current_frame = movie.currentframe() + ((LSNES.frame_boundary == "end") and 1 or 0)
    if info.current_frame == 0 then info.current_frame = 1 end
    if info.Lastframe_emulated <= info.Framecount then
        info.current_starting_subframe = movie.current_first_subframe() + 1
        if LSNES.frame_boundary == "end" then
            info.current_starting_subframe = info.current_starting_subframe + info.Size_last_frame
        end
    else
        info.current_starting_subframe = info.Subframecount + (info.current_frame - info.Framecount)
    end
    
    -- Next frame info (only relevant in readonly mode)
    info.Nextframe = info.Lastframe_emulated + 1  -- unused
    info.Starting_subframe_next_frame = info.Final_subframe_last_frame + 1  -- unused
    
    -- TEST INPUT
    info.last_input_computed = LSNES.get_input(info.Subframecount)
end

function LSNES.get_screen_info()
    LSNES.left_gap = LSNES.left_gap or OPTIONS.left_gap  -- Lateral gaps
    LSNES.right_gap = LSNES.right_gap or OPTIONS.right_gap
    LSNES.top_gap = LSNES.top_gap or OPTIONS.top_gap
    LSNES.bottom_gap = LSNES.bottom_gap or OPTIONS.bottom_gap
    
    LSNES.Padding_left = tonumber(settings.get("left-border"))  -- Advanced configuration: padding dimensions
    LSNES.Padding_right = tonumber(settings.get("right-border"))
    LSNES.Padding_top = tonumber(settings.get("top-border"))
    LSNES.Padding_bottom = tonumber(settings.get("bottom-border"))
    
    LSNES.Border_left = math.max(LSNES.Padding_left, LSNES.left_gap)  -- Borders' dimensions
    LSNES.Border_right = math.max(LSNES.Padding_right, LSNES.right_gap)
    LSNES.Border_top = math.max(LSNES.Padding_top, LSNES.top_gap)
    LSNES.Border_bottom = math.max(LSNES.Padding_bottom, LSNES.bottom_gap)
    
    LSNES.Buffer_width, LSNES.Buffer_height = gui.resolution()  -- Game area
    if LSNES.Video_callback then  -- The video callback messes with the resolution
        LSNES.Buffer_middle_x, LSNES.Buffer_middle_y = LSNES.Buffer_width, LSNES.Buffer_height
        LSNES.Buffer_width = 2*LSNES.Buffer_width
        LSNES.Buffer_height = 2*LSNES.Buffer_height
    else
        LSNES.Buffer_middle_x, LSNES.Buffer_middle_y = LSNES.Buffer_width//2, LSNES.Buffer_height//2  -- Lua 5.3
    end
    
	LSNES.Screen_width = LSNES.Buffer_width + LSNES.Border_left + LSNES.Border_right  -- Emulator area
	LSNES.Screen_height = LSNES.Buffer_height + LSNES.Border_top + LSNES.Border_bottom
    LSNES.AR_x = 2
    LSNES.AR_y = 2
end


-- Changes transparency of a color: result is opaque original * transparency level (0.0 to 1.0). Acts like gui.opacity() in Snes9x.
function draw.change_transparency(color, transparency)
    -- Sane transparency
    if transparency >= 1 then return color end  -- no transparency
    if transparency <= 0 then return COLOUR.transparency end    -- total transparency
    
    -- Sane colour
    if color == -1 then return -1 end
    
    local a = color>>24  -- Lua 5.3
    local rgb = color - (a<<24)
    local new_a = 0x100 - math.ceil((0x100 - a)*transparency)
    return (new_a<<24) + rgb
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
function draw.text_position(x, y, text, font_width, font_height, always_on_client, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local border_left     = LSNES.Border_left
    local border_right    = LSNES.Border_right
    local border_top      = LSNES.Border_top
    local border_bottom   = LSNES.Border_bottom
    local buffer_width    = LSNES.Buffer_width
    local buffer_height   = LSNES.Buffer_height
    
    -- text processing
    local text_length = text and string.len(text)*font_width or font_width  -- considering another objects, like bitmaps
    
    -- actual position, relative to game area origin
    x = ((not ref_x or ref_x == 0) and x) or x - math.floor(text_length*ref_x)
    y = ((not ref_y or ref_y == 0) and y) or y - math.floor(font_height*ref_y)
    
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
function draw.text(x, y, text, text_color, bg_color, halo_color, always_on_client, always_on_game, ref_x, ref_y)
    -- Read external variables
    local font_name = draw.Font_name or false
    local font_width  = draw.font_width()
    local font_height = draw.font_height()
    text_color = text_color or COLOUR.text
    bg_color = bg_color or -1--COLOUR.background -- EDIT
    halo_color = halo_color or COLOUR.halo
    
    -- Apply transparency
    text_color = draw.change_transparency(text_color, draw.Text_global_opacity * draw.Text_local_opacity)
    bg_color = draw.change_transparency(bg_color, draw.Bg_global_opacity * draw.Bg_local_opacity)
    halo_color = draw.change_transparency(halo_color, draw.Text_global_opacity * draw.Text_local_opacity)
    
    -- Calculate actual coordinates and plot text
    local x_pos, y_pos, length = draw.text_position(x, y, text, font_width, font_height,
                                    always_on_client, always_on_game, ref_x, ref_y)
    ;
    draw.font[font_name](x_pos, y_pos, text, text_color, bg_color, halo_color)
    
    return x_pos + length, y_pos + font_height, length
end


function draw.alert_text(x, y, text, text_color, bg_color, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local font_width  = LSNES.FONT_WIDTH
    local font_height = LSNES.FONT_HEIGHT
    
    local x_pos, y_pos, text_length = draw.text_position(x, y, text, font_width, font_height, false, always_on_game, ref_x, ref_y)
    
    text_color = draw.change_transparency(text_color, draw.Text_global_opacity * draw.Text_local_opacity)
    bg_color = draw.change_transparency(bg_color, draw.Bg_global_opacity * draw.Bg_local_opacity)
    gui.text(x_pos, y_pos, text, text_color, bg_color)
    
    return x_pos + text_length, y_pos + font_height, text_length
end


local function draw_over_text(x, y, value, base, color_base, color_value, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    value = decode_bits(value, base)
    local x_end, y_end, length = draw.text(x, y, base, color_base, color_bg, nil, always_on_client, always_on_game, ref_x, ref_y)
    draw.font[Font](x_end - length, y_end - draw.font_height(), value, color_value or COLOUR.text)
    
    return x_end, y_end, length
end


-- Returns frames-time conversion
local function frame_time(frame)
    if not LSNES.rom or not LSNES.rom.is_loaded then return "no time" end
    
    local total_seconds = frame / LSNES.rom.game_fps
    local hours, minutes, seconds = bit.multidiv(total_seconds, 3600, 60)
    seconds = math.floor(seconds)
    
    local miliseconds = 1000* (total_seconds%1)
    if hours == 0 then hours = "" else hours = string.format("%d:", hours) end
    local str = string.format("%s%.2d:%.2d.%03.0f", hours, minutes, seconds, miliseconds)
    return str
end


-- draw a pixel given (x,y) with SNES' pixel sizes
function draw.pixel(x, y, color, shadow)
    if shadow and shadow ~= COLOUR.transparent then
        gui.rectangle(x*LSNES.AR_x - 1, y*LSNES.AR_y - 1, 2*LSNES.AR_x, 2*LSNES.AR_y, 1, shadow, color)
    else
        gui.solidrectangle(x*LSNES.AR_x, y*LSNES.AR_y, LSNES.AR_x, LSNES.AR_y, color)
    end
end

-- draws a line given (x,y) and (x',y') with given scale and SNES' pixel thickness
function draw.line(x1, y1, x2, y2, color)
    x1, y1, x2, y2 = x1*LSNES.AR_x, y1*LSNES.AR_y, x2*LSNES.AR_x, y2*LSNES.AR_y
    if x1 == x2 then
        gui.line(x1, y1, x2, y2 + 1, color)
        gui.line(x1 + 1, y1, x2 + 1, y2 + 1, color)
    elseif y1 == y2 then
        gui.line(x1, y1, x2 + 1, y2, color)
        gui.line(x1, y1 + 1, x2 + 1, y2 + 1, color)
    else
        gui.line(x1, y1, x2 + 1, y2 + 1, color)
    end
end


-- draws a box given (x,y) and (x',y') with SNES' pixel sizes
function draw.box(x1, y1, x2, y2, ...)
    -- Draw from top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    gui.rectangle(x1*LSNES.AR_x, y1*LSNES.AR_y, (x2 - x1 + 1)*LSNES.AR_x, (y2 - y1 + 1)*LSNES.AR_x, LSNES.AR_x, ...)
end


-- draws a rectangle given (x,y) and dimensions, with SNES' pixel sizes
function draw.rectangle(x, y, w, h, ...)
    gui.rectangle(x*LSNES.AR_x, y*LSNES.AR_y, w*LSNES.AR_x, h*LSNES.AR_y, LSNES.AR_x, ...)
end


-- Background opacity functions
function draw.increase_opacity()
    if draw.Text_global_opacity <= 0.9 then draw.Text_global_opacity = draw.Text_global_opacity + 0.1
    else
        if draw.Bg_global_opacity <= 0.9 then draw.Bg_global_opacity = draw.Bg_global_opacity + 0.1 end
    end
end


function draw.decrease_opacity()
    if  draw.Bg_global_opacity >= 0.1 then draw.Bg_global_opacity = draw.Bg_global_opacity - 0.1
    else
        if draw.Text_global_opacity >= 0.1 then draw.Text_global_opacity = draw.Text_global_opacity - 0.1 end
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
        width, height = gui.font_width(), gui.font_height()
        x, y, width = draw.text_position(x, y, object, width, height, always_on_client, always_on_game, ref_x, ref_y)
    elseif object_type == "userdata" then  -- lsnes specific
        width, height = object:size()
        x, y = draw.text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
    elseif object_type == "boolean" then
        width, height = LSNES.FONT_WIDTH, LSNES.FONT_HEIGHT
        x, y = draw.text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
    else error"Type of buttton not supported yet"
    end
    
    -- draw the button
    if button_pressed then
        gui.box(x, y, width, height, 1, 0x808080, 0xffffff, 0xe0e0e0) -- unlisted colour
    else
        gui.box(x, y, width, height, 1)
    end
    
    if object_type == "string" then
        draw.text(x, y, object, COLOUR.button_text)
    elseif object_type == "userdata" then
        object:draw(x, y)
    elseif object_type == "boolean" then
        gui.solidrectangle(x +1, y + 1, width - 2, height - 2, 0x00ff00)  -- unlisted colour
    end
    
    -- updates the table of buttons
    table.insert(Script_buttons, {x = x, y = y, width = width, height = height, object = object, action = fn})
end

-- Display buttons on screen --TODO
--[[local function screen_buttons()
    -- Reads external variables
    local Border_left     = LSNES.Border_left
    local Border_right    = LSNES.Border_right
    local Border_top      = LSNES.Border_top
    local Border_bottom   = LSNES.Border_bottom
    local Buffer_width    = LSNES.Buffer_width
    local Buffer_height   = LSNES.Buffer_height
    -- Font
    Font = false
    	
	if User_input.mouse_inwindow == 1 then
	
        create_button(-Border_left, Buffer_height + Border_bottom, Cheat.allow_cheats and "Cheats: allowed" or "Cheats: blocked",
            function() Cheat.allow_cheats = not Cheat.allow_cheats end, {always_on_client = true, ref_y = 1.0})
        ;
                
        -- Quick save movie/state buttons
        Font = "snes9xluasmall"
        draw.text(0, Buffer_height - 2*gui.font_height(), "Save?", COLOUR.text, COLOUR.background)
        
        create_button(0, Buffer_height, "Movie", function()
                local hint = movie.get_rom_info()[1].hint
                local current_time = string.gsub(system_time(), ":", ".")
                local filename = string.format("%s-%s(MOVIE).lsmv", current_time, hint)
                if not file_exists(filename) then
                    exec("save-movie " .. filename)
                    return
                else
                    print("Movie " .. filename .. " already exists.")
                    return
                end
            end, {always_on_game = true})
        ;
        
        create_button(5*gui.font_width() + 1, Buffer_height + LSNES.FONT_HEIGHT, "State", function()
                local hint = movie.get_rom_info()[1].hint
                local current_time = string.gsub(system_time(), ":", ".")
                local filename = string.format("%s-%s(STATE).lsmv", current_time, hint)
                if not file_exists(filename) then
                    exec("save-state " .. filename)
                    return
                else
                    print("State " .. filename .. " already exists.")
                    return
                end
            end, {always_on_game = true})
        ;
        
        --Options_menu.adjust_lateral_paddings()
    else
        if Cheat.allow_cheats then  -- show cheat status anyway
            Font = "snes9xtext"
            draw.text(-Border_left, Buffer_height + 10*Border_bottom, "Cheats: allowed", COLOUR.warning, true, false, 0.0, 1.0)
        end
    end
	Font = false
end]]

-- Converts the in-game (x, y) to SNES-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
    local x_screen = (x - camera_x)
    local y_screen = (y - camera_y) - Y_CAMERA_OFF
    
    return x_screen, y_screen
end


-- Creates lateral gaps
local function create_gaps()
    gui.left_gap(LSNES.left_gap)  -- for input display -- TEST
    gui.right_gap(LSNES.right_gap)
    gui.top_gap(LSNES.top_gap)
    gui.bottom_gap(LSNES.bottom_gap)
end


local function show_movie_info()
    -- Font
    draw.Font_name = false
    draw.opacity(1.0, 1.0)
    
    local y_text = - LSNES.Border_top
    local x_text = 0
    local width = draw.font_width()
    
    local rec_color = LSNES.movie.Readonly and COLOUR.text or COLOUR.warning
    local recording_bg = LSNES.movie.Readonly and COLOUR.background or COLOUR.warning_bg 
    
    -- Read-only or read-write?
    local movie_type = LSNES.movie.Readonly and "Movie " or "REC "
    x_text = draw.alert_text(x_text, y_text, movie_type, rec_color, recording_bg)
    
    -- Frame count
    local movie_info
    if LSNES.movie.Readonly then
        movie_info = string.format("%d(%d)/%d", LSNES.movie.Lastframe_emulated, LSNES.movie.Starting_subframe_last_frame, LSNES.movie.Framecount) -- edit
    else
        movie_info = string.format("%d(%d)", LSNES.movie.Lastframe_emulated, LSNES.movie.Starting_subframe_last_frame) -- edit
    end
    x_text = draw.text(x_text, y_text, movie_info)  -- Shows the latest frame emulated, not the frame being run now
    
    -- Rerecord and lag count
    x_text = draw.text(x_text, y_text, string.format("|%d ", LSNES.movie.Rerecords), COLOUR.weak)
    x_text = draw.text(x_text, y_text, LSNES.movie.Lagcount, COLOUR.warning)
    
    -- Run mode and emulator speed
    local lsnesmode_info
    if LSNES.Lsnes_speed == "turbo" then
        lsnesmode_info = fmt(" %s(%s)", LSNES.Runmode, LSNES.Lsnes_speed)
    elseif LSNES.Lsnes_speed ~= 1 then
        lsnesmode_info = fmt(" %s(%.0f%%)", LSNES.Runmode, 100*LSNES.Lsnes_speed)
    else
        lsnesmode_info = fmt(" %s", LSNES.Runmode)
    end
    
    x_text = draw.text(x_text, y_text, lsnesmode_info, COLOUR.weak)
    
    local str = frame_time(LSNES.movie.Lastframe_emulated)    -- Shows the latest frame emulated, not the frame being run now
    draw.alert_text(LSNES.Buffer_width, LSNES.Buffer_height, str, COLOUR.text, recording_bg, false, 1.0, 1.0)
    
    if LSNES.Is_lagged then
        gui.textHV(LSNES.Buffer_middle_x - 3*LSNES.FONT_WIDTH, 2*LSNES.FONT_HEIGHT, "Lag", COLOUR.warning, draw.change_transparency(COLOUR.warning_bg, draw.Bg_global_opacity))
    end
    
end



--#############################################################################
-- CUSTOM CALLBACKS --


local function is_new_rom()
    Previous.rom = LSNES.rom_hash
    
    if not movie.rom_loaded() then
        LSNES.rom_hash = "NULL ROM"
    else LSNES.rom_hash = movie.get_rom_info()[1].sha256
    end
    
    return Previous.rom == LSNES.rom
end


local function on_new_rom()
    if not is_new_rom() then return end
    
    LSNES.get_rom_info()
    print"NEW ROM FAGGOTS"
end


--#############################################################################
-- MAIN --


LSNES.subframe_update = false
gui.subframe_update(LSNES.subframe_update)  -- TODO: this should be true when paused or in heavy slowdown -- EDIT


-- KEYHOOK callback
on_keyhook = Keys.altkeyhook

-- Key presses:
Keys.registerkeypress(OPTIONS.hotkey_increase_opacity, function() draw.increase_opacity() end)
Keys.registerkeypress(OPTIONS.hotkey_decrease_opacity, function() draw.decrease_opacity() end)
Keys.registerkeypress("mouse_left", left_click)
Keys.registerkeypress("period", function()
    LSNES.subframe_update = not LSNES.subframe_update
    gui.subframe_update(LSNES.subframe_update)
    gui.repaint()
end)


function on_frame_emulated()
    LSNES.Is_lagged = memory.get_lag_flag()
    LSNES.frame_boundary = "end"
end

function on_frame()
    LSNES.frame_boundary = "start"
    if not movie.rom_loaded() then  -- only useful with null ROM
        gui.repaint()
    end
	
end


function on_snoop(port, controller, button, value)
    if port == 0 then LSNES.frame_boundary = "polling" end
end


gui.font_width = function()
    local font = OPTIONS.use_custom_fonts and Font or false
    return CUSTOM_FONTS[font] and CUSTOM_FONTS[font].width or LSNES_FONT_WIDTH
end

gui.font_height = function(font)
    local font = OPTIONS.use_custom_fonts and Font or false
    return CUSTOM_FONTS[font] and CUSTOM_FONTS[font].height or LSNES_FONT_HEIGHT
end


---[[test
function LSNES.size_frame(frame)
    return frame > 0 and movie.frame_subframes(frame) or -1
end

function LSNES.get_input(subframe)
    local total = LSNES.movie.Subframecount or movie.get_size()
    
    return (subframe <= total and subframe > 0) and movie.get_frame(subframe - 1) or false
end

function LSNES.treat_input(input_obj)
    local presses = {}
    local index = 1
    local number_controls = OPTIONS.display_all_controllers and LSNES.controller.total_controllers or 1
    for lcid = 1, number_controls do
        local port, cnum = input.lcid_to_pcid2(lcid)
        for control = 1, LSNES.controller[lcid].button_count do
            presses[index] = input_obj:get_button(port, cnum, control-1) and LSNES.controller[lcid].symbols[control] or "."
            index = index + 1
        end
        
        presses[index] = "|"
        index = index + 1
    end
    
    return table.concat(presses)
end

function LSNES.input_to_string(inputframe)
    local remove_num = 8
    local input_line = inputframe:serialize()
    local str = string.sub(input_line, remove_num) -- remove the "FR X Y|" from input
    
    str = string.gsub(str, "%p", "\032") -- ' '
    str = string.gsub(str, "u", "\094")  -- '^'
    str = string.gsub(str, "d", "v")     -- 'v'
    str = string.gsub(str, "l", "\060")  -- '<'
    str = string.gsub(str, "r", "\062")  -- '>'
    
    return str
end

function subframe_to_frame(subf)
    local total_frames = LSNES.movie.Framecount or movie.count_frames(nil)
    local total_subframes = LSNES.movie.Subframecount or movie.get_size(nil)
    
    if total_subframes < subf then return total_frames + (subf - total_subframes) --end
    else return movie.subframe_to_frame(subf - 1) end
end
--]]

--[[ serialized version of display_input
function LSNES.display_input_serialized()
    -- Font
    draw.Font_name = false
    draw.opacity(1.0, 1.0)
    local width  = draw.font_width()
    local height = draw.font_height()
    local before = LSNES.Buffer_height//(2*height)
    local after = before
    local y_text = LSNES.Buffer_middle_y - height
    local color, subframe_around = nil, false
    
    local current_subindex, current_subframe, current_frame, frame, input, subindex
    current_subframe = LSNES.movie.current_starting_subframe + LSNES.movie.internal_subframe - 1
    current_frame = LSNES.movie.current_frame
    --
    subframe = current_subframe - 1
    frame = LSNES.movie.internal_subframe == 1 and current_frame - 1 or current_frame
    
    for subframe = subframe, subframe - before + 1, -1 do
        if subframe <= 0 then break end
        
        local is_nullinput, is_startframe, is_delayedinput
        local raw_input = LSNES.get_input(subframe)
        if raw_input then
            input = LSNES.input_to_string(raw_input)
            is_startframe = raw_input:get_button(0, 0, 0)
            if not is_startframe then subframe_around = true end
            color = is_startframe and COLOUR.text or 0xff
        elseif frame == LSNES.movie.current_frame then
            input = LSNES.input_to_string(LSNES.movie.last_input_computed)
            is_delayedinput = true
            color = 0x00ffff
        else
            input = "NULLINPUT"
            is_nullinput = true
            color = 0xff8080
        end
        
        draw.text(-LSNES.Border_left, y_text, fmt("%d %s", frame, input), color)
        
        if is_startframe or is_nullinput then
            frame = frame - 1
        end
        y_text = y_text - height
    end
    
    draw.line(-LSNES.Border_left, 0, -1, 0, 0xff)
    draw.line(-LSNES.Border_left, LSNES.Buffer_height//4, -1, LSNES.Buffer_height//4, 0xff0000)
    draw.line(-LSNES.Border_left, LSNES.Buffer_height//2, -1, LSNES.Buffer_height//2, 0xff)
    
    y_text = LSNES.Buffer_middle_y
    frame = current_frame
    
    for subframe = current_subframe, current_subframe + after - 1 do
        local raw_input = LSNES.get_input(subframe)
        local input = raw_input and LSNES.input_to_string(raw_input) or "Unrecorded"
        
        if raw_input and raw_input:get_button(0, 0, 0) then
            if subframe ~= current_subframe then frame = frame + 1 end
            color = COLOUR.text
        else
            if raw_input then
                subframe_around = true
                color = 0xff
            else
                color = 0x00ff00
            end
        end
        
        draw.text(-LSNES.Border_left, y_text, fmt("%d %s", frame, input), color)
        y_text = y_text + height
        
        if not raw_input then break end
    end
    
    LSNES.subframe_update = subframe_around
    gui.subframe_update(LSNES.subframe_update)
end
--]]

-- Gets input of the 1st controller / Might be deprecated someday...
local Joypad = {}
function get_joypad()
    Joypad["B"] = input.get2(1, 0, 0)
    Joypad["Y"] = input.get2(1, 0, 1)
    Joypad["select"] = input.get2(1, 0, 2)
    Joypad["start"] = input.get2(1, 0, 3)
    Joypad["up"] = input.get2(1, 0, 4)
    Joypad["down"] = input.get2(1, 0, 5)
    Joypad["left"] = input.get2(1, 0, 6)
    Joypad["right"] = input.get2(1, 0, 7)
    Joypad["A"] = input.get2(1, 0, 8)
    Joypad["X"] = input.get2(1, 0, 9)
    Joypad["L"] = input.get2(1, 0, 10)
    Joypad["R"] = input.get2(1, 0, 11)
end

function LSNES.display_input()
    -- Font
    draw.Font_name = false
    draw.opacity(1.0, 1.0)
    local width  = draw.font_width()
    local height = draw.font_height()
    local before = LSNES.Buffer_height//(2*height)
    local after = before
    local y_text = LSNES.Buffer_middle_y - height
    local color, subframe_around = nil, false
    
    local current_subindex, current_subframe, current_frame, frame, input, subindex
    current_subframe = LSNES.movie.current_starting_subframe + LSNES.movie.internal_subframe - 1
    current_frame = LSNES.movie.current_frame
    --
    subframe = current_subframe - 1
    frame = LSNES.movie.internal_subframe == 1 and current_frame - 1 or current_frame
    
    for subframe = subframe, subframe - before + 1, -1 do
        if subframe <= 0 then break end
        
        local is_nullinput, is_startframe, is_delayedinput
        local raw_input = LSNES.get_input(subframe)
        if raw_input then
            input = LSNES.treat_input(raw_input)
            is_startframe = raw_input:get_button(0, 0, 0)
            if not is_startframe then subframe_around = true end
            color = is_startframe and COLOUR.text or 0xff
        elseif frame == LSNES.movie.current_frame then
            input = LSNES.treat_input(LSNES.movie.last_input_computed)
            is_delayedinput = true
            color = 0x00ffff
        else
            input = "NULLINPUT"
            is_nullinput = true
            color = 0xff8080
        end
        
        draw.text(-LSNES.Border_left, y_text, input, color)
		draw.text(-LSNES.Border_left + 105, y_text, subframe, color)
        
        if is_startframe or is_nullinput then
            frame = frame - 1
        end
        y_text = y_text - height
    end
    
    draw.line(-LSNES.Border_left, 0, -1, 0, 0xff)
    draw.line(-LSNES.Border_left, LSNES.Buffer_height//4, -1, LSNES.Buffer_height//4, 0xff0000)
    draw.line(-LSNES.Border_left, LSNES.Buffer_height//2, -1, LSNES.Buffer_height//2, 0xff)
    
    y_text = LSNES.Buffer_middle_y
    frame = current_frame
    
    for subframe = current_subframe, current_subframe + after - 1 do
        local raw_input = LSNES.get_input(subframe)
        local input = raw_input and LSNES.treat_input(raw_input) or "Unrecorded"
        
        if raw_input and raw_input:get_button(0, 0, 0) then
            if subframe ~= current_subframe then frame = frame + 1 end
            color = COLOUR.text
        else
            if raw_input then
                subframe_around = true
                color = 0xff
            else
                color = 0x00ff00
            end
        end
        
        draw.text(-LSNES.Border_left, y_text, input, color)
        y_text = y_text + height
        
        if not raw_input then break end
    end
    
    LSNES.subframe_update = subframe_around
    gui.subframe_update(LSNES.subframe_update)
end
--]]


-- Function that is called from the paint and video callbacks
-- from_paint is true if this was called from on_paint/ false if from on_video
local function main_paint_function(authentic_paint, from_paint)
    -- Initial values, don't make drawings here
    read_raw_input()
    LSNES.get_emu_status()
    
    if not LSNES.rom then LSNES.rom = LSNES.get_rom_info() ; print"> Read rom info" end
    if not LSNES.controller then LSNES.controller = LSNES.get_controller_info() ; print"> Read controller info" end
    LSNES.get_movie_info()
    LSNES.left_gap = math.min(8*(LSNES.controller.total_buttons + LSNES.controller.total_controllers + 14), 500) -- TEST
    LSNES.get_screen_info()
    create_gaps()
    
    if not authentic_paint then gui.text(-8, -16, "*") end
    --draw.text(- LSNES.Border_left, -20, tostringx(LSNES.controller.ports))
    --draw.text(-96, -16, movie.currentframe().." "..tostring(LSNES.frame_boundary))
    --gui.text( -140, -16, LSNES.movie.internal_subframe, "yellow", "black") -- EDIT
    
    LSNES.display_input()
    
    show_movie_info(OPTIONS.display_movie_info)
	
	--############################################################################################################
	--############################################################################################################
	-- MAIN INFO --
	local game_mode = u8(WRAM.game_mode)
	local level = u8(WRAM.level)
	local timer = u16(WRAM.timer)
	local camera_x = u16(WRAM.camera_x)
	local camera_y = u16(WRAM.camera_y)
	local x = u16(WRAM.x)
	local y = u16(WRAM.y)
	local x_sub = u8(WRAM.x_sub)
	local y_sub = u8(WRAM.y_sub)
	local direction = u8(WRAM.direction)
	local x_speed = s8(WRAM.x_speed)
	local x_subspeed = u8(WRAM.x_subspeed)
	local y_speed = s8(WRAM.y_speed)
	local y_subspeed = u8(WRAM.y_subspeed)
	local on_ground = u8(WRAM.on_ground)
	local last_valid_x = u16(WRAM.last_valid_x)
	local last_valid_y = u16(WRAM.last_valid_y)
	local status = u8(WRAM.status)
	local is_smashing = u8(WRAM.is_smashing)
	local invincibility_timer = u8(WRAM.invincibility_timer)
	local lives = u8(WRAM.lives)
	local health = u8(WRAM.health)
	local stones = u8(WRAM.stones)
	local bowling_balls = u8(WRAM.bowling_balls)
	local score = u8(WRAM.score)
	local throw_power = u8(WRAM.throw_power)
	local idle_timer = u16(WRAM.idle_timer)
	local boss_hp = u8(WRAM.boss_hp)
	
	local i = 0
	local delta_x = 8
    local delta_y = 18
    local table_x = 0
    local table_y = LSNES.AR_y*32
	local left_arrow = "<-"
	local right_arrow = "->"
	local temp_color
	
	if game_mode >= 50 and game_mode <= 173 then -- Levels and bosses
		-- Camera
		draw.text(110, 0, fmt("Camera (%d, %d)", camera_x, camera_y), COLOUR.text, COLOUR.background)
		
		-- Level
		local level_name
		if level == 0 then level_name = "Quarry 1" elseif level == 1 then level_name = "Quarry 2" elseif level == 2 then level_name = "Bedrock 1"
		elseif level == 4 then level_name = "Jungle 3" elseif level == 5 then level_name = "Jungle 2" elseif level == 6 then level_name = "Jungle 1" 
		elseif level == 7 then level_name = "Volcanic 1" elseif level == 8 then level_name = "Volcanic 2" elseif level == 9 then level_name = "Volcanic 3"
		elseif level == 12 then level_name = "Machine 1" elseif level == 13 then level_name = "Machine 2" elseif level == 14 then level_name = "Machine 3"
		elseif level == 16 then level_name = "Quarry 3" elseif level == 17 then level_name = "Jungle 4" end
		level = string.upper(fmt("%02x", level))
		draw.text(260, 0, fmt("Level %s (%s)", level, level_name), COLOUR.text, COLOUR.background)

		-- Fred
		if direction == 0 then direction = right_arrow else direction = left_arrow end
		draw.text(table_x, table_y + i*delta_y, fmt("Pos (%+d.%02x, %+d.%02x) %s", x, x_sub, y, y_sub, direction), COLOUR.text, COLOUR.background)
		i = i + 1
		
		draw.text(table_x, table_y + i*delta_y, fmt("Speed (%+d.%02x, %+d.%02x)", x_speed, x_subspeed, y_speed, y_subspeed), COLOUR.text, COLOUR.background)
		i = i + 1
		
		if on_ground == 0 then on_ground = "no" temp_color = COLOUR.warning else on_ground = "yes" temp_color = COLOUR.positive end
		draw.text(table_x, table_y + i*delta_y, fmt("On ground:"), COLOUR.text, COLOUR.background)
		draw.text(table_x + 10*delta_x + 2, table_y + i*delta_y, fmt("%s", on_ground), temp_color, COLOUR.background)
		i = i + 1
		
		status = string.upper(fmt("%02x", status))
		draw.text(table_x, table_y + i*delta_y, fmt("Status: %s", status), COLOUR.text, COLOUR.background)
		i = i + 1
		
		if is_smashing == 0 then is_smashing = "no" temp_color = COLOUR.warning else is_smashing = "yes" temp_color = COLOUR.positive end
		draw.text(table_x, table_y + i*delta_y, fmt("Smashing:"), COLOUR.text, COLOUR.background)
		draw.text(table_x + 9*delta_x + 2, table_y + i*delta_y, fmt("%s", is_smashing), temp_color, COLOUR.background)
		i = i + 1
		
		draw.text(table_x, table_y + i*delta_y, fmt("Last valid pos\n(%+d, %+d)", last_valid_x, last_valid_y), COLOUR.text, COLOUR.background)
		i = i + 2
		
		if invincibility_timer ~= 0 then
			draw.text(table_x, table_y + i*delta_y, fmt("Invincibility: %d", invincibility_timer), COLOUR.text, COLOUR.background)
			i = i + 1
		end
		
		if idle_timer ~= 300 then
			draw.text(table_x, table_y + i*delta_y, fmt("Idle timer: %d", idle_timer), COLOUR.text, COLOUR.background)
			i = i + 1
		end

		local x_screen, y_screen = screen_coordinates(x, y, camera_x, camera_y)
		draw.pixel(x_screen, y_screen, COLOUR.text, COLOUR.background) -- Fred's position pixel
	
		if throw_power ~= 0 then -- stone trajectory based on throw power
			draw.text(table_x, table_y + i*delta_y, fmt("Throw power: %d", throw_power), COLOUR.text, COLOUR.background)
			
			local dir, x_off, x_base
			if direction == right_arrow then
				dir = 1
				x_off = 64
			else
				dir = -1
				x_off = -5
			end
			for k = 0, throw_power, 2 do
				BITMAPS.stone_animation[k%(#BITMAPS.stone_animation)+1]:draw(2*x_screen + x_off + dir*k*7, 2*y_screen + 24)--, "◯", COLOUR.extsprites[2])	
			end	
			x_base = 2*x_screen + x_off + dir*(throw_power - 1)*7
			local b = 1
			local index = b%(#BITMAPS.stone_animation) + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*24, 2*y_screen + 24 + 1) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*48, 2*y_screen + 24 + 3) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*70, 2*y_screen + 24 + 12) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*92, 2*y_screen + 24 + 23) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*114, 2*y_screen + 24 + 36) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*136, 2*y_screen + 24 + 52) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*156, 2*y_screen + 24 + 71) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*176, 2*y_screen + 24 + 93) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*196, 2*y_screen + 24 + 119) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*216, 2*y_screen + 24 + 147) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*236, 2*y_screen + 24 + 179) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*256, 2*y_screen + 24 + 214) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*276, 2*y_screen + 24 + 253) b = b + 1
			BITMAPS.stone_animation[index]:draw(x_base  + dir*296, 2*y_screen + 24 + 295)
			
			i = i + 1
		end
		
		-- Sprites
		table_x = 520
		local sprite_count = 0
		for id = 0, 2*FLINT.sprite_max, 2 do
			draw.opacity(1, 1)
			
			local sprite_status = u8(WRAM.sprite_status +id)
			local sprite_x = u16(WRAM.sprite_x +id)
			local sprite_y = u16(WRAM.sprite_y +id)
			local sprite_x_sub = u8(WRAM.sprite_x_sub +id)
			local sprite_y_sub = u8(WRAM.sprite_y_sub +id)
			local sprite_x_speed = s8(WRAM.sprite_x_speed +id)
			local sprite_x_subspeed = u8(WRAM.sprite_x_subspeed +id)
			local sprite_y_speed = s8(WRAM.sprite_y_speed +id)
			local sprite_y_subspeed = u8(WRAM.sprite_y_subspeed +id)
			local x_screen, y_screen = screen_coordinates(sprite_x, sprite_y, camera_x, camera_y)
			
			if 2*x_screen > 0 and 2*x_screen < 512 and 2*y_screen > 0 and 2*y_screen < 448 then
				draw.opacity(1, 1)
			else
				draw.opacity(0.5, 1)
			end

			if sprite_status ~= 0 then -- slot is being used
				sprite_status = string.upper(fmt("%02x", sprite_status))
				local sprite_string = fmt("#%02d %s (%d.%02x, %d.%02x)", id/2, sprite_status, sprite_x, sprite_x_sub, sprite_y, sprite_y_sub)
				local sprite_color = COLOUR.sprites[(id/2)%(#COLOUR.sprites) + 1]
				
				-- Draw the sprite table
				--if x_screen > 512 then
				--	draw.opacity(0.5, 1)
				--end
				draw.text(table_x, table_y + sprite_count * delta_y, sprite_string, sprite_color, COLOUR.background)
				-- Draw info right above the sprite
				draw.text(2*x_screen, 2*y_screen, fmt("#%02d", id/2), sprite_color, COLOUR.background, COLOUR.halo, true)
				draw.pixel(x_screen, y_screen, sprite_color, COLOUR.background) -- sprite position pixel
				
				--Draw boss HP right above it
				if sprite_status == "B0" then -- Caveman boss -- in hex, due to sprite_status = string.upper(fmt("%02x", sprite_status))
					draw.text(2*x_screen + 110, 2*y_screen + 10, fmt("HP: %d", boss_hp), COLOUR.text, COLOUR.warning_bg)					
				elseif  sprite_status == "B6" then -- Tiger boss (Jungle 4)
					draw.text(2*x_screen + 35, 2*y_screen + 80, fmt("HP: %d", boss_hp), COLOUR.text, COLOUR.warning_bg)
				end
				
				sprite_count = sprite_count + 1
			end
		end
		draw.opacity(1, 1)
		draw.text(table_x + 55, table_y - delta_y, fmt("Sprites: %02d", sprite_count), COLOUR.text, COLOUR.background)
		
		-- Extended Sprites
		if sprite_count > 14 then
			table_y = table_y + (sprite_count + 2) * delta_y
		else
			table_y = 340
		end
		local extsprite_count = 0
		for id = 0, 2*FLINT.extended_sprite_max, 2 do
			draw.opacity(1, 1)
			
			local extsprite_status = u8(WRAM.extsprite_status +id)
			local extsprite_x = u16(WRAM.extsprite_x +id)
			local extsprite_y = u16(WRAM.extsprite_y +id)
			local extsprite_x_sub = u8(WRAM.extsprite_x_sub +id)
			local extsprite_y_sub = u8(WRAM.extsprite_y_sub +id)
			local extsprite_x_speed = s8(WRAM.extsprite_x_speed +id)
			local extsprite_x_subspeed = u8(WRAM.extsprite_x_subspeed +id)
			local extsprite_y_speed = s8(WRAM.extsprite_y_speed +id)
			local extsprite_y_subspeed = u8(WRAM.extsprite_y_subspeed +id)
			local x_screen, y_screen = screen_coordinates(extsprite_x, extsprite_y, camera_x, camera_y)
			
			if 2*x_screen > 0 and 2*x_screen < 512 and 2*y_screen > 0 and 2*y_screen < 448 then
				draw.opacity(1, 1)
			else
				draw.opacity(0.5, 1)
			end
			
			if extsprite_status ~= 0 then -- slot is being used
				extsprite_status = string.upper(fmt("%02x", extsprite_status))
				local extsprite_string = fmt("#%02d %s (%d.%02x, %d.%02x)", id/2, extsprite_status, extsprite_x, extsprite_x_sub, extsprite_y, extsprite_y_sub)
				local extsprite_color = COLOUR.extsprites[(id/2)%(#COLOUR.extsprites) + 1]
				
				--draw.Font_name = "snes9xluaclever"
				-- Draw the extended sprite table
				if x_screen > 512 then
					draw.opacity(0.5, 1)
				end
				draw.text(table_x, table_y + extsprite_count * delta_y, extsprite_string, extsprite_color, COLOUR.background)
				-- Draw info right above the extended sprite
				draw.text(2*x_screen, 2*y_screen, fmt("#%02d", id/2), extsprite_color, COLOUR.background, COLOUR.halo, true)
				draw.pixel(x_screen, y_screen, extsprite_color, COLOUR.background) -- extended sprite position pixel
				
				extsprite_count = extsprite_count + 1
			end
		end
		draw.opacity(1, 1)
		draw.text(table_x + 30, table_y - delta_y, fmt("Extd. sprites: %02d", extsprite_count), COLOUR.text, COLOUR.background)
	end
	
	--create_button(200, 100, "TEST")
	
	--############################################################################################################
	--############################################################################################################
end

--#############################################################################
-- CHEATS

local under_invincibility
local function Cheat_invincibility()
	--local under_invincibility --= false
	--if Keys.KeyPress["I"] then under_invincibility = not under_invincibility end
	if pad_press[1].select and pad_down[1].up then --under_invincibility = not under_invincibility end
	--if under_invincibility then
		w8(WRAM.invincibility, 1)
		draw.text(0, 450, "Invincibility password enabled", COLOUR.warning)
	else
		draw.text(0, 450, "Invincibility password disabled", COLOUR.text)
	end
end

local function Cheat_stage_skip()
	local under_stage_skip
	if (Joypad["select"] == 1 and Joypad["R"] == 1) then under_stage_skip = not under_stage_skip end
	if under_stage_skip then
		w8(WRAM.stage_skip, 1)
		draw.text(0, 468, "Stage Skip password enabled", COLOUR.warning)
	else
		draw.text(0, 468, "Stage Skip password disabled", COLOUR.text)
	end
end

function Cheat_free_movement()
	local under_free_move
    if (Joypad["select"] == 1 and Joypad["up"] == 1) then under_free_move = true end
    if (Joypad["select"] == 1 and Joypad["down"] == 1) then under_free_move = false end
    if under_free_move then
		local x_pos, y_pos = u16(WRAM.x), u16(WRAM.y)
		local pixels = (Joypad["Y"] == 1 and 7) or (Joypad["X"] == 1 and 4) or 1  -- how many pixels per frame
    
		if Joypad["left"] == 1 then x_pos = x_pos - pixels end
		if Joypad["right"] == 1 then x_pos = x_pos + pixels end
		if Joypad["up"] == 1 then y_pos = y_pos - pixels end
		if Joypad["down"] == 1 then y_pos = y_pos + pixels end
    
		-- manipulate some values
		w16(WRAM.x, x_pos)
		w16(WRAM.y, y_pos)
		w16(WRAM.invincibility_timer, 300)
    
		gui.status("Cheat(movement):", fmt("at %d/frame", pixels))
    end
end

--#############################################################################

local function left_click()
    for _, field in ipairs(Script_buttons) do
        
        -- if mouse is over the button
        if mouse_onregion(field.x, field.y, field.x + field.width, field.y + field.height) then
                field.action()
                return
        end
    end
end

local draw = draw
function on_paint(authentic_paint)
    main_paint_function(authentic_paint, true)
	--screen_buttons()
    
    --[=[
    --local _input = LSNES.get_input(LSNES.movie.Lastframe_emulated)
    for i=1, 50 do
        --LSNES.display_input_serialized()
        LSNES.display_input()
    end
    --]=]
	
	--Cheats
	--Cheat_invincibility()
	--Cheat_stage_skip()
	--Cheat_free_movement()
end


function on_video()
    LSNES.Video_callback = true
    main_paint_function(false, false)
    LSNES.Video_callback = false
end


-- Loading a state
function on_pre_load()
    LSNES.frame_boundary = "start" --false -- TEST
    LSNES.Is_lagged = false
    
end


-- Functions called on specific events
function on_readwrite()
    --LSNES.movie = false
    
    gui.repaint()
end


-- Rewind functions
function on_rewind()
    print"ON REWIND"
    LSNES.frame_boundary = "start"
    
    --gui.repaint()
end


function on_movie_lost(kind)
    print("ON MOVIE LOST", kind)
    
    if kind == "reload" then  -- just before reloading the ROM in rec mode or closing/loading new ROM
        LSNES.rom = false
        LSNES.controller = false
        
    elseif kind == "load" then -- this is called just before loading / use on_post_load when needed
        LSNES.controller = false
        
    end
    
end


gui.repaint()
