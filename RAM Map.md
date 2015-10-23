Notes before reading:<br>
- Extended sprites are Fred's projectiles (rocks and bowling balls);
- I consider 256 subpixels per pixel;

Address|     Size     |Description
:------------: | :-------------: | ------------- 
$7E0018|2 bytes|Camera X position.
$7E001A|2 bytes|Camera Y position.
$7E003C|1 byte|Game Mode, maybe<sup>[1]</sup>:<br>#03 = Title screen,<br>#09 = Level name with Snes controller,<br>#25 = Game Over,<br>#41 = Options,<br>#50 = Boss (Quarry 3),<br>#67 = Level (Jungle 1, 2, 3), Boss (Jungle 4),<br>#80 = Level (Bedrock 1),<br>#96 = Level (Machine 2, 3),<br>#108 = Level (Volcanic 1),<br>#120 = Level (Quarry 1, 2, Machine 1),<br>#132 = Level (Volcanic 2),<br>#173 = Level (Volcanic 3),<br>#222 = Password screen,<br>#246 = Ocean logo intro + language option,<br>#247 = Cutscene,<br>#253 = Hiscores / Credits|
$7E008C|2 bytes|Frame counter, maybe<sup>[1]</sup>. Resets to zero during screen transitions, and pauses when the game is paused.|
$7E0622|1 byte|Stage skip password flag.
$7E0624|1 byte|Invincibility password flag.
$7E0725|1 byte|Fred's graphical direction, maybe<sup>[1]</sup>: #40 = facing right, #104 = facing left. It's controlled by the effective direction ($7E0CB9).
$7E0946|58 bytes<sup>[2]</sup>|Sprite status table.
$7E0980|8 bytes<sup>[2]</sup>|Extended sprite status table. E.g.: #16 = stone about to be thrown, #17 = stone thrown, #20 = bowling ball about to be thrown, #21 = bowling ball thrown.
$7E0988|2 bytes|X position.
$7E098A|58 bytes<sup>[2]</sup>|Sprite X position table.
$7E09C4|8 bytes<sup>[2]</sup>|Extended sprite X position table.
$7E09CC|2 bytes|Y position.
$7E09CE|58 bytes<sup>[2]</sup>|Sprite Y position table.
$7E0A08|8 bytes<sup>[2]</sup>|Extended sprite Y position table.
