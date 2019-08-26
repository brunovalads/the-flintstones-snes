# RAM Map

**Notes before reading**:<br>
- There are 29 sprite slots, and 4 extended sprite slots;
- Their table sizes are doubled: 58 bytes table for 29 sprites, 8 bytes table for 4 extended sprites. The "high byte" of the pair is often unused, I guess the producers made the tables according to the X/Y position tables, that use the second byte of the pair;
- Extended sprites are Fred's projectiles (stones and bowling balls);
- I consider 256 subpixels per pixel;

Address|     Size     |Description
:------------: | :-------------: | ------------- 
$7E001C|2 bytes|Camera X position.
$7E001E|2 bytes|Camera Y position.
$7E003C|1 byte|Graphics set, maybe<sup>[[1]]</sup>. A list of valid values can be found [here](./RAM_Map_Extra_Info.md#7e003c---graphics-set-maybe).
$7E0040|2 bytes|Game mode.  A list of valid values can be found [here](./RAM_Map_Extra_Info.md#7e0040-2-bytes---game-mode).
$7E004A|1 byte|Mirror of $7E1E12. 
$7E008C|2 bytes|Frame counter, maybe<sup>[[1]]</sup>. Resets to zero during screen transitions, and pauses when the game is paused.|
$7E00D7|2 bytes|[Considering a rectangle with corner 2 beign the opposite corner of 1]<br>Fred's hitbox corner 1 x pos.
$7E00D9|2 bytes|Fred's hitbox corner 2 x pos.
$7E00DB|2 bytes|Fred's hitbox corner 1 y pos.
$7E00DD|2 bytes|Fred's hitbox corner 2 y pos.
$7E00DF|2 bytes|Sprite platforming interaction left point x pos.
$7E00E1|2 bytes|Sprite platforming interaction right point x pos.
$7E00E3|2 bytes|Sprite platforming interaction left point y pos.
$7E00E5|2 bytes|Sprite platforming interaction right point y pos.
$7E00E7|2 bytes|[Considering a rectangle with corner 2 beign the opposite corner of 1]<br>Club hitbox corner 1 x pos.
$7E00E9|2 bytes|Club hitbox corner 2 x pos.
$7E00EB|2 bytes|Club hitbox corner 1 y pos.
$7E00ED|2 bytes|Club hitbox corner 2 y pos.
$7E0622|2 bytes|Stage skip password flag.
$7E0624|2 bytes|Invincibility password flag.
$7E0636|1 byte|Is paused flag.
$7E0725|1 byte|Fred's graphical direction, maybe<sup>[[1]]</sup>: #40 = facing right, #104 = facing left. It's controlled by the effective direction ($7E0CB9).
$7E0944|1 byte|Fred is loaded flag. #$01 = Fred is loaded, in levels, cutscenes, Password screen, Ocean intro. Also is #$02 when is walking in cutscenes and #$03 when jumping in cutscenes.
$7E0946|58 bytes|Sprite type table. Can be interpreted as a status sometimes.
$7E0980|8 bytes|Extended sprite type table. Uses the values #$10, #$11, #$14 and #$15 from the sprite type table. Can be interpreted as a status sometimes.
$7E0988|2 bytes|X position.
$7E098A|58 bytes|Sprite X position table.
$7E09C4|8 bytes|Extended sprite X position table.
$7E09CC|2 bytes|Y position.
$7E09CE|58 bytes|Sprite Y position table.
$7E0A08|8 bytes|Extended sprite Y position table.
$7E0A11|1 byte|Accumulated X subpixels.
$7E0A13|58 bytes|Sprite accumulated X subpixels table.
$7E0A4D|8 bytes|Extended sprite accumulated X subpixels table.
$7E0A55|1 byte|Accumulated Y subpixels.
$7E0A57|58 bytes|Sprite accumulated Y subpixels table.
$7E0A91|8 bytes|Extended sprite accumulated Y subpixels table.
$7E0A98|2 bytes<sup>[[1]]</sup>|Fred's animation poses. A list of valid values can be found [here](https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM_Map_Extra_Info.md#7e0a98---freds-animation-poses).
$7E0A9A|58 bytes|Sprite animation table, maybe<sup>[[1]]</sup>.
$7E0AD4|8 bytes|Extended sprite animation table, maybe<sup>[[1]]</sup>.
$7E0ADE|58 bytes|Sprite misc table 1.
$7E0B18|8 bytes|Extended sprite misc table 1.
$7E0B22|58 bytes|Sprite misc table 2.
$7E0B5C|8 bytes|Extended sprite misc table 2.
$7E0B66|58 bytes|Sprite misc table 3.
$7E0BA0|8 bytes|Extended sprite misc table 3.
$7E0BAA|58 bytes|Sprite misc table 4.
$7E0BE4|8 bytes|Extended sprite misc table 4.
$7E0CB9|1 byte|Fred's effective direction, maybe<sup>[[1]]</sup>: #00 = facing right, #64 = facing left.
$7E0CFD|1 byte|Something related with which layer does Fred overlay. #32 = in normal game, some stuff overlay Fred; #48 = in dying animation, Fred overlays everything execpt sprites.
$7E0D84|2 bytes|X speed. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0D86|58 bytes|Sprite X speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DC0|8 bytes|Extended sprite X speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DC8|2 bytes|Y speed. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DCA|58 bytes|Sprite Y speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0E04|8 bytes|Extended sprite Y speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0E94|1 byte|Is on ground flag. #01 = yes, #00 = no. When set, Fred can jump.
$7E0ED0|8 bytes|Extended sprite is on ground flag.
$7E0FEE|2 bytes|Mirror of X speed ($7E0D84). The low byte resets to 255 when not playing.
$7E0FF0|2 bytes|Last valid X position to respawn (if the player falls on a pit).
$7E0FF2|2 bytes|Last valid Y position to respawn (if the player falls on a pit).
$7E0FF6|1 byte|Fred's status. A list of valid values can be found [here](https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM_Map_Extra_Info.md#7e0ff6---freds-status).
$7E0FF8|2 bytes|X starting position in levels, Game Over screen and Password screen.
$7E0FFA|2 bytes|Y starting position in levels, Game Over screen and Password screen.
$7E1000|1 byte|Is smashing flag. When #01, Fred hits enemies and rocks.
$7E1010|1 byte|Something related to be standing still, increments by 4 every 8 frames.
$7E101A|2 bytes|Selection cursor x position (in the table, not in pixels) in the Hiscore section when the player puts its name (when beats the game).
$7E101C|2 bytes|Selection cursor y position (in the table, not in pixels) in the Hiscore section when the player puts its name (when beats the game).
$7E101E|2 bytes|Position on Hiscore table, after beating the game.
$7E1020|1 byte|Current character slot in the Hiscore section when the player puts its name (when beats the game). Can be interpreted as name size too.
$7E1022|2 bytes|Only updated in the Hiscore section when the player puts its name (when beats the game). Increases every frame, looping between #00 and #07.
$7E102E|8 bytes|Player name in Hiscores (while choosing it when beats the game), each byte for each character. #65~#90 = A~Z, #32 = blank space, #46 = not writen (dot). There are other valid values too (for numbers and special characters), but inaccessible.
$7E1066|1 byte|Platform in mud pointer, it's the number of the current platform to rise. Updates right when you step on these platforms.
$7E140F|1 byte|Language option: #00 = brittish english, #01 = american english, #02 = spanish, #03 = german, #04 = italian, #05 = french.
$7E1485|2 bytes|Width of the current level, in blocks. $7E15B6 seems like a mirror of the low byte.
$7E1487|2 bytes|Height of the current level, in blocks.
$7E1491|2 bytes|Is on a platform-like sprite flag. When set, Fred can jump.
$7E1D51|1 byte|Invincibility timer. The player has 120 frames of invincibility after being hit or falling in a pit.
$7E1D5B|1 byte|Current level. A list of valid values can be found [here](https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM_Map_Extra_Info.md#7e1d5b---current-level).
$7E1D65|2 bytes|Lives.
$7E1D69|2 bytes|Health (Fred faces in the life counter, #02 = normal, #01 = tongue out, #00 = tongue out and spiked hair).
$7E1D6D|2 bytes|Stones.
$7E1D71|2 bytes|Bowling balls.
$7E1D75|2 bytes|Score. The maximum score you can see is 042767, which corresponds to $1D75 = 15 and $1D76 = 167, any point further the addresses are updated normally, but the counter becomes 000000, and you won't get in the Hiscores. Note: the first digit on the counter is never used, there isn't a RAM address for it.
$7E1D8D|2 bytes|Time. Each game second takes 64 frames, so in NTSC (60Hz), 16 game seconds = 15 real seconds.
$7E1D95|1 byte|Score counter on screen, 6th digit.
$7E1D97|1 byte|Score counter on screen, 5th digit.
$7E1D99|1 byte|Score counter on screen, 4th digit.
$7E1D9B|1 byte|Score counter on screen, 3rd digit.
$7E1D9D|1 byte|Score counter on screen, 2nd digit.
$7E1DA1|1 byte|Time counter on screen, 3rd digit.
$7E1DA3|1 byte|Time counter on screen, 2nd digit.
$7E1DA5|1 byte|Time counter on screen, 1st digit.
$7E1DA7|1 byte|Live counter on screen, 2nd digit.
$7E1DA9|1 byte|Live counter on screen, 1st digit.
$7E1DAB|1 byte|Bowling ball counter on screen, 2nd digit.
$7E1DAD|1 byte|Bowling ball counter on screen, 1st digit.
$7E1DAF|1 byte|Stone counter on screen, 2nd digit.
$7E1DB1|1 byte|Stone counter on screen, 1st digit.
$7E1DB3|1 byte|Mirror of $7E1D95.
$7E1DB5|1 byte|Mirror of $7E1D97.
$7E1DB7|1 byte|Mirror of $7E1D99.
$7E1DB9|1 byte|Mirror of $7E1D9B.
$7E1DBB|1 byte|Mirror of $7E1D9D.
$7E1DBF|1 byte|Mirror of $7E1DA1.
$7E1DC1|1 byte|Mirror of $7E1DA3.
$7E1DC3|1 byte|Mirror of $7E1DA5.
$7E1DC5|1 byte|Mirror of $7E1DA7.
$7E1DC7|1 byte|Mirror of $7E1DA9.
$7E1DC9|1 byte|Mirror of $7E1DAB.
$7E1DCB|1 byte|Mirror of $7E1DAD.
$7E1DCD|1 byte|Mirror of $7E1DAF.
$7E1DCF|1 byte|Mirror of $7E1DB1.
$7E1DD5|2 bytes|Counter for how long you're holding a stone to throw (holding X). When hits #120 you burn you hand and waste the stone. This determines how far the stone can go. E.g.: if you hold for 20 frames the stone will float without y speed for 20 frames. The high byte is never used, but is updated if you poke a value bigger than #120.
$7E1DD7|2 bytes|Idle timer. It's #300 when player is acting, then decrements whenever the player is idle. When reaches #00, activates the idle animation.
$7E1DEB|2 bytes|Lava wave (in Volcanic 3) x pos.
$7E1DED|2 bytes|Lava wave (in Volcanic 3) y pos.
$7E1E0E|2 bytes|Lava flood (in Volcanic 2) y pos (static).
$7E1E10|2 bytes|Lava flood (in Volcanic 2) y pos (oscillating).
$7E1E12|1 byte|Lava flood (in Volcanic 2) y pos in screen.
$7E1ED6|1 byte|Boss HP. The Caveman boss (Quarry 3) has #15, the Tiger boss (Jungle 4) has #5.
$7E2000|2 bytes|Width of the level loaded, in blocks. Is set during the level loading/name screen.
$7E2002|2 bytes|Height of the level loaded, in blocks. Is set during the level loading/name screen.
$7E2004|? bytes<sup>[[1]]</sup>|Map16 table of tiles (low byte). It's more like the ID of the tile, e.g.: #$9f = blank tile. A list of valid values can be found [here](./RAM_Map_Extra_Info.md#7e2004---map16-table-of-tiles-low-byte).
$7E2005|? bytes<sup>[[1]]</sup>|Map16 table of tiles (high byte). It's more like the properties of the tile. A list of valid values can be found [here](./RAM_Map_Extra_Info.md#7e2005---map16-table-of-tiles-high-byte).

### Observations:
1. These addresses need further research, since I'm just one and started this study just some months ago.

[1]: https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM_Map.md#observations
