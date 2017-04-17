# RAM Map Extra Info
---
### $7E003C - Graphics set, *_maybe_*
Note: the address $7E003D seems to be part of it too, since is #$A7 only in levels, cutscenes, Password, Hiscores, intro, language option; and is #$A8 in the rest.

Value (in hex)|Description
|:---:|---|
03|Title screen
09|Level name with Snes controller
19|Game Over
29|Options
32|Boss (Quarry 3)
43|Level (Jungle 1, 2, 3), Boss (Jungle 4)
50|Level (Bedrock 1)
60|Level (Machine 2, 3)
6C|Level (Volcanic 1)
78|Level (Quarry 1, 2, Machine 1)
84|Level (Volcanic 2)
AD|Level (Volcanic 3)
DE|Password screen
F6|Ocean logo intro + language option
F7|Cutscenes
FD|Hiscores, Credits
---
### $7E0040 (2 bytes) - Game Mode
Value (in hex)|Description
|:---:|---|
87B5|Title screen
87CD|Cutscenes
8DAA|Hiscores
B23B|Level
BC5B|Password screen
C1CD|Options
CA42|Level name
CB8A|Game over screen
CED7|Intro
D18E|Language option
---
### $7E0A98 - Fred's animation poses
*Under construction*

---
### $7E0FF6 - Fred's status
Value (in hex)|Description
|:---:|---|
00|standing still, walking, pushing boulder, in car, surfing
01|standing still (Ocean® screen)
03|walking left (Ocean® screen)
04|ducking
06|jumping
07|yabadabadoo (Ocean® screen)
08|throwing stone
0A|throwing bowling ball
0C|walking facing the screen (Password sliding up)
0E|walking facing the screen (Password sliding down)
10|dying
12|taking damage
14|club smashing
15|ledge hanging
19|climbing ledge, tree
1B|climbing vine
1D|idle animation (eating, sweating, heating or sleeping)
---
### $7E1D5B - Current level
Notes:
- The unused levels have correct names on the level name screen;
- I think levels 0A and 0B are ice themed, due to the music (an unused one);
- Level $12 loads properly but without the boss, level $13 doesn't load properly.

Value (in hex)|Description
|:---:|---|
00|Quarry 1
01|Quarry 2
02|Bedrock 1
03|Bedrock 2 [UNUSED]
04|Jungle 3
05|Jungle 2
06|Jungle 1
07|Volcanic 1
08|Volcanic 2
09|Volcanic 3
0A|Ice 1? [UNUSED]
0B|Ice 2? [UNUSED]
0C|Machine 1
0D|Machine 2
0E|Machine 3
0F|Machine 1 without sprites [UNUSED]
10|Quarry 3 (boss)
11|Jungle 4 (boss)
12|Volcanic 4 (boss) [UNUSED]
13|Machine 4 (boss) [UNUSED]
---

### $7E2004 - Map16 table of tiles (low byte)
*Under construction*

---

### $7E2005 - Map16 table of tiles (high byte)
*Under construction*

---
