#RAM Map

**Notes before reading**:<br>
- There are 29 sprite slots, and 4 extended sprite slots;
- Their table sizes are doubled: 58 bytes table for 29 sprites, 8 bytes table for 4 extended sprites. The "high byte" of the pair is often unused, I guess the producers made the tables according to the X/Y position tables, that use the second byte of the pair;
- Extended sprites are Fred's projectiles (rocks and bowling balls);
- I consider 256 subpixels per pixel;

Address|     Size     |Description
:------------: | :-------------: | ------------- 
$7E0018|2 bytes|Camera X position.
$7E001A|2 bytes|Camera Y position.
$7E003C|1 byte|Game Mode, maybe<sup>[[1]](/1./)</sup>:<br>#03 = Title screen,<br>#09 = Level name with Snes controller,<br>#25 = Game Over,<br>#41 = Options,<br>#50 = Boss (Quarry 3),<br>#67 = Level (Jungle 1, 2, 3), Boss (Jungle 4),<br>#80 = Level (Bedrock 1),<br>#96 = Level (Machine 2, 3),<br>#108 = Level (Volcanic 1),<br>#120 = Level (Quarry 1, 2, Machine 1),<br>#132 = Level (Volcanic 2),<br>#173 = Level (Volcanic 3),<br>#222 = Password screen,<br>#246 = Ocean logo intro + language option,<br>#247 = Cutscene,<br>#253 = Hiscores / Credits|
$7E008C|2 bytes|Frame counter, maybe<sup>[[1]](/1./)</sup>. Resets to zero during screen transitions, and pauses when the game is paused.|
$7E0622|1 byte|Stage skip password flag.
$7E0624|1 byte|Invincibility password flag.
$7E0725|1 byte|Fred's graphical direction, maybe<sup>[[1]](/1./)</sup>: #40 = facing right, #104 = facing left. It's controlled by the effective direction ($7E0CB9).
$7E0946|58 bytes|Sprite status table.
$7E0980|8 bytes|Extended sprite status table. E.g.: #16 = stone about to be thrown, #17 = stone thrown, #20 = bowling ball about to be thrown, #21 = bowling ball thrown.
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
$7E0A98|2 bytes<sup>[[1]](/1./)</sup>|Fred's animation poses. A list of valid values can be found here<sup>[2][2]</sup>.
$7E0A9A|58 bytes|Sprite animation table, maybe<sup>[1][1]</sup>.
$7E0AD4|8 bytes|Extended sprite animation table, maybe<sup>[[1]](/1./)</sup>.
$7E0CB9|1 byte|Fred's effective direction, maybe<sup>[[1]](/1./)</sup>: #00 = facing right, #64 = facing left.
$7E0CFD|1 byte|Something related with which layer does Fred overlay. #32 = in normal game, some stuff overlay Fred; #48 = in dying animation, Fred overlays everything execpt sprites.
$7E0D84|2 bytes|X speed. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0D86|58 bytes|Sprite X speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DC0|8 bytes|Extended sprite X speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DC8|2 bytes|Y speed. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0DCA|58 bytes|Sprite Y speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0E04|8 bytes|Extended sprite Y speed table. The low byte is the subspeed, in subpixels/frame, and the high byte is the speed, in pixels/frame.
$7E0E94|1 byte|Is on ground flag. #01 = yes, #00 = no.
$7E0FEE|2 bytes|Mirror of X speed ($7E0D84). The low byte resets to 255 when not playing.
$7E0FF0|2 bytes|Last valid X position to respawn (if the player falls on a pit).
$7E0FF2|2 bytes|Last valid Y position to respawn (if the player falls on a pit).
$7E0FF6|1 byte|Fred's status. A list of valid values can be found here<sup>[[2]](/2./)</sup>.
$7E1010|1 byte|Something related to be standing still, increments by 4 every 8 frames.
$7E140F|1 byte|Language option: #00 = brittish english, #01 = american english, #02 = spanish, #03 = german, #04 = italian, #05 = french.
$7E1D51|1 byte|Invincibility timer. The player has 120 frames of invincibility after being hit or falling in a pit.
$7E1D5B|1 byte|Current level. A list of valid values can be found here<sup>[[2]](/2./)</sup>.
$7E1D65|1 byte|Lives.
$7E1D69|1 byte|Health (Fred faces in the life counter, #02 = normal, #01 = tongue out, #00 = tongue out and spiked hair).
$7E1D6D|1 byte|Stones.
$7E1D71|1 byte|Bowling balls.
$7E1D75|2 bytes|Score. The maximum score you can see is 042767, which corresponds to $1D75 = 15 and $1D76 = 167, any point further the addresses are updated normally, but the counter becomes 000000. Note: the first digit on the counter is never used, there isn't a RAM address for it.
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
$7E1DD7|2 bytes|Idle timer. It's #300 when player is acting, then decrements whenever the player is idle. When reaches #00, activates the idle animation.
$7E1ED6|1 byte|Boss HP.

###Observations:
1. These addresses need further research, since I'm just one and started this study a couple weeks ago.
2. I still need to create these reference pages.
[1]: https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM%20Map.md#Observations
[2]: https://github.com/brunovalads/the-flintstones-snes/blob/master/RAM%20Map.md#Observations
