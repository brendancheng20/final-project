# Use $1, $2, $3, $4 as signal registers - asynchronous button toggles that control
# flow of program. Button inputs directly to regfile in processor, branch
# instructions handle the rest
#
# At each new screen, need to load screen from memory
#
# Reserve $30 for toggling screen mux (aka loading different backgrounds)
###### $30 VALUE MAPPING:
# 0 = start screen
# 1 = select game mode screen
# 2 = leaderboard screen
# 3 = standard game screen - arrow on 3 of a kind
# 4 = standard game screen - arrow on 4 of a kind
# 5 = standard game screen - arrow on full house
# 6 = standard game screen - arrow on sm. straight
# 7 = standard game screen - arrow on lg. straight
# 8 = standard game screen - arrow on chance
# 9 = standard game screen - arrow on yahtzee
#
#
########################### SCREENS #######################################
nop
addi $28 $0 12
addi $31 $0 50000
add $31 $31 $31 # $31 contains 100000
add $31 $31 $31 # $31 contains 200000
add $31 $31 $31 # $31 contains 400000
#
# Loop for instructsion at start of program
#
start: nop # start of program
bne $1 $0 prepgamesetting # if $1 gets toggled, jump to function for prepping game settings screen
nop
nop
nop
bne $2 $0 prepleader # if $2 gets toggled by selecting leaderboard, jump to function for prepping the screen
nop
j start # return to start of start loop if no branches were taken


#
# Leaderboard = loop for showing leaderboard screen
#
leaderboard: nop #
bne $1 $0 prepstart # if $1 toggled, return to start
nop
j leaderboard # Jump to start of leaderboard loop if no branches were taken

#
# Loop for choosing game type
#
gamesetting: nop
bne $1 $0 prepsingleplayer # $1 toggles single player game
nop
nop
nop
bne $2 $0 prepmultiplayer # $2 toggle multiplayer game
nop
nop
nop
bne $3 $0 prepcpu # $3 toggles cpu game
nop
nop
nop
bne $4 $0 prepstart # $4 is back to start
nop
j gamesetting # If no options are chosen, return to start of loop

####################### GAME MODES #############################################

##### Game rules
# $1 assigned to hold die 1
# $2 assigned to hold die 2
# $3 assigned to hold die 3
# $4 assigned to hold die 4
# $5 assigned to hold die 5
# $6 assigned to select left
# $7 assigned to select right
# $8 assigned to enter button
# $9 assigned to roll button
# --------
# $10 toggles cpu player
# --------
# $11 assigned to die 1 value
# $12 assigned to die 2 value
# $13 assigned to die 3 value
# $14 assigned to die 4 value
# $15 assigned to die 5 value
# $17 assigned to total score
# $18 index for array value in memory that stores whether or not the hand has
#     been selected
# $19 assigned to number of rolls taken this turn
# $20 assigned to value of selector
#       - set to -1 if nothing is selected
#       - if >= 0, at least one hand has been selected
# $21 assigned to selected value for that iteration
#
# $27 used for delay counter - prevents button pressing from interfering with
#     game performance
# $28 stores 12 for selector use
# $29 = random value for die
#
# All button toggles have event handlers, which are specified in GAME FUNCTIONS
#
singlegame: nop
# roll
bne $9 $0 doroll # Branch if roll is to be performed
j singlegame
afterroll: nop
# Now check for dice to be held - only if still rolls left
nop
bne $1 $0 hold1
nop
bne $2 $0 hold2
nop
bne $3 $0 hold3
nop
bne $4 $0 hold4
nop
bne $5 $0 hold5
nop
bne $6 $0 toggleleft
nop
bne $7 $0 toggleright
nop
bne $8 $0 selecthand
nop
bne $9 $0 doroll
nop
j afterroll

cpugame: nop
# bne $18 $0 hand1
j cpuroll

multiplayer: nop

j multiplayer

####################### GAME FUNCTIONS #########################################

##### Roll functions
# Roll remaining dice
doroll: nop
addi $27 $27 1
bne $27 $31 doroll
add $27 $0 $0
bne $9 $0 doroll
nop
nop
bne $19 $0 validroll
nop
nop
j afterroll # if no rolls left, continue with game
validroll: nop
nop
addi $19 $19 -1 # subtract number of rolls
nop
j roll1
# bne $11 $0 roll1 # if die 1 is not set, roll die 1
doneroll1: nop
j roll2
# bne $12 $0 roll2
doneroll2: nop
j roll3
# bne $13 $0 roll3
doneroll3: nop
j roll4
# bne $14 $0 roll4
doneroll4: nop
j roll5
doneroll5: nop# bne $15 $0 roll5
nop
nop
j afterroll

roll1: nop
# roll die 1
bne $11 $0 doneroll1
nop
add $11 $0 $29
nop
nop
j doneroll1

roll2: nop
bne $12 $0 doneroll2
nop
add $12 $0 $29
nop
nop
nop
j doneroll2

roll3: nop
bne $13 $0 doneroll3
nop
add $13 $0 $29
nop
nop
j doneroll3

roll4: nop
bne $14 $0 doneroll4
nop
add $14 $0 $29
nop
nop
nop
nop
j doneroll4

roll5: nop
nop
bne $15 $0 doneroll5
add $15 $0 $29
nop
j doneroll5

##### Hold functions

hold1: nop
addi $27 $27 1
bne $27 $31 hold1
add $27 $0 $0
bne $1 $0 hold1
nop
bne $19 $0 dohold1 # If hold is allowed
nop
j afterroll
dohold1: add $11 $0 $0
nop
j afterroll

hold2: nop
addi $27 $27 1
bne $27 $31 hold2
add $27 $0 $0
bne $2 $0 hold2
nop
nop
bne $19 $0 dohold2 # If hold is allowed
nop
j afterroll
dohold2: add $12 $0 $0
nop
j afterroll

hold3: nop
addi $27 $27 1
bne $27 $31 hold3
add $27 $0 $0
bne $3 $0 hold3
nop
nop
bne $19 $0 dohold3 # If hold is allowed
nop
j afterroll
dohold3: add $13 $0 $0
nop
j afterroll

hold4: nop
addi $27 $27 1
bne $27 $31 hold4
add $27 $0 $0
bne $4 $0 hold4
nop
nop
bne $19 $0 dohold4 # If hold is allowed
nop
j afterroll
dohold4: add $14 $0 $0
nop
j afterroll

hold5: nop
addi $27 $27 1
bne $27 $31 hold5
add $27 $0 $0
bne $5 $0 hold5
nop
nop
bne $19 $0 dohold5 # If hold is allowed
nop
j afterroll
dohold5: add $15 $0 $0
nop
j afterroll

#### Selection functions

# Starting point for toggle left
toggleleft: nop
addi $27 $27 1
bne $27 $31 toggleleft
add $27 $0 $0
bne $6 $0 toggleleft
nop
addi $20 $20 -1 # subtract one to move left
blt $20 $0 wrapleft # if subtraction takes us past 0, take us to right most point
nop
j afterroll
wrapleft: nop
addi $20 $0 12
j afterroll

# Starting point for toggle right
toggleright: nop
addi $27 $27 1
bne $27 $31 toggleright
add $27 $0 $0
bne $7 $0 toggleright
nop
addi $20 $20 1
blt $28 $20 wrapright # if $20 > 12, reset to position 0
nop
j afterroll
wrapright: nop
add $20 $0 $0
j afterroll

# Starting point for select hand
selecthand: nop
addi $27 $27 1
bne $27 $31 selecthand
add $27 $0 $0
bne $8 $0 selecthand
nop
add $21 $0 $20 # set output register to $21
j addhand

##### Adding functions - add score once hand selection has been made
addhand: nop # landing point
add $22 $0 $0 # set $22 to 0 for testing which hand is selected
# if selection 0
nop
bne $21 $22 check1to12
nop
j hand0 # jump to handler for hand 0
check1to12: nop
# if selection 1
addi $22 $0 1
nop
bne $21 $22 check2to12
nop
j hand1 # jump to handler for hand 1
check2to12: nop
# if selection 2
addi $22 $0 2
nop
bne $21 $22 check3to12
nop
j hand2 # jump to handler for hand 2
check3to12: nop
# if selection 3
addi $22 $0 3
nop
bne $21 $22 check4to12
nop
j hand3
check4to12: nop
addi $22 $0 4
nop
bne $21 $22 check5to12
nop
j hand4
check5to12: nop
addi $22 $0 5
nop
bne $21 $22 check6to12
nop
j hand5
check6to12: nop
addi $22 $0 6
nop
bne $21 $22 check7to12
nop
j hand6
check7to12: nop
addi $22 $0 7
nop
bne $21 $22 check8to12
nop
j hand7
check8to12: nop
addi $22 $0 8
nop
bne $21 $22 check9to12
nop
j hand8
check9to12: nop
addi $22 $0 9
nop
bne $21 $22 check10to12
nop
j hand9
check10to12: nop
addi $22 $0 10
nop
bne $21 $22 check11to12
nop
j hand10
check11to12: nop
addi $22 $0 11
nop
bne $21 $22 hand12
nop
j hand11
j nextturn # TODO remove this

# Ones hand selected
hand0: nop
# reg 11-15 dice 1-5
# total score in reg 17
# registers 22-26 free

addi $22, $0, 1		# 22 now represents a 1

bne $11, $22, onenotaone
addi $17, $17, 1
onenotaone: nop

bne $12, $22, twonotaone
addi $17, $17, 1
twonotaone: nop

bne $13, $22, threenotaone
addi $17, $17, 1
threenotaone: nop

bne $14, $22, fournotaone
addi $17, $17, 1
fournotaone: nop

bne $15, $22, fivenotaone
addi $17, $17, 1
fivenotaone: nop

j nextturn

# Twos hand selected
hand1: nop

addi $22, $0, 2		# 22 now represents a 2

bne $11, $22, onenotatwo
addi $17, $17, 2
onenotatwo: nop

bne $12, $22, twonotatwo
addi $17, $17, 2
twonotatwo: nop

bne $13, $22, threenotatwo
addi $17, $17, 2
threenotatwo: nop

bne $14, $22, fournotatwo
addi $17, $17, 2
fournotatwo: nop

bne $15, $22, fivenotatwo
addi $17, $17, 2
fivenotatwo: nop

j nextturn

# Threes hand selected
hand2: nop

addi $22, $0, 3		# 22 now represents a 3

bne $11, $22, onenotathree
addi $17, $17, 3
onenotathree: nop

bne $12, $22, twonotathree
addi $17, $17, 3
twonotathree: nop

bne $13, $22, threenotathree
addi $17, $17, 3
threenotathree: nop

bne $14, $22, fournotathree
addi $17, $17, 3
fournotathree: nop

bne $15, $22, fivenotathree
addi $17, $17, 3
fivenotathree: nop

j nextturn

# Fours hand selected
hand3: nop

addi $22, $0, 4		# 22 now represents a 4

bne $11, $22, onenotafour
addi $17, $17, 4
onenotafour: nop

bne $12, $22, twonotafour
addi $17, $17, 4
twonotafour: nop

bne $13, $22, threenotafour
addi $17, $17, 4
threenotafour: nop

bne $14, $22, fournotafour
addi $17, $17, 4
fournotafour: nop

bne $15, $22, fivenotafour
addi $17, $17, 4
fivenotafour: nop

j nextturn

# Fives hand selected
hand4: nop

addi $22, $0, 5		# 22 now represents a 5

bne $11, $22, onenotafive
addi $17, $17, 5
onenotafive: nop

bne $12, $22, twonotafive
addi $17, $17, 5
twonotafive: nop

bne $13, $22, threenotafive
addi $17, $17, 5
threenotafive: nop

bne $14, $22, fournotafive
addi $17, $17, 5
fournotafive: nop

bne $15, $22, fivenotafive
addi $17, $17, 5
fivenotafive: nop

j nextturn

# Sixes hand selected
hand5: nop

addi $22, $0, 6		# 22 now represents a 6

bne $11, $22, onenotasix
addi $17, $17, 6
onenotasix: nop

bne $12, $22, twonotasix
addi $17, $17, 6
twonotasix: nop

bne $13, $22, threenotasix
addi $17, $17, 6
threenotasix: nop

bne $14, $22, fournotasix
addi $17, $17, 6
fournotasix: nop

bne $15, $22, fivenotasix
addi $17, $17, 6
fivenotasix: nop

j nextturn

# 3 of a kind
hand6: nop

#add $22, $11, $0		# 22 holds value of dice 1
#add $23, $12, $0		# 23 holds value of dice 2
#add $24, $13, $0		# 24 holds value of dice 3
#bne $14, $11, checkdice42
#bne $15, $11, checkdice
# 3 of a kind ! dice 1,3,5
#add $17, $17, $11
#add $17, $17, $14
#add $17, $17, $15

add $22, $0, $0		# how many are like me?
#add $23, $0, $0		# what value is this three of a kind?
addi $24, $0, 2		# what we're looking for

#check dice 1 and 2
bne $11, $12, check13
addi $22, $22, 1	# dice one and two are the same! we have TWO of a kind

check13: nop
bne $11, $13, check14
addi $22, $22, 1
bne $22, $24, check14
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn
check14: nop
bne $11, $14, check15
addi $22, $22, 1
bne $22, $24, check15
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn
check15: nop
bne $11, $15, check23
addi $22, $22, 1
bne $22, $24, check23
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn

check23: nop
add $22, $0, $0
bne $12, $13, check24
addi $22, $22, 1
bne $22, $24, check24
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
j nextturn
check24: nop
bne $12, $14, check25
addi $22, $22, 1
bne $22, $24, check25
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
j nextturn
check25: nop
bne $12, $15, check34
addi $22, $22, 1
bne $22, $24, check34
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
j nextturn

check34: nop
add $22, $0, $0
bne $13, $14, check35
addi $22, $22, 1
bne $22, $24, check35
add $17, $17, $13
add $17, $17, $13
add $17, $17, $13
j nextturn
check35: nop
bne $13, $15, nothreeofakind
addi $22, $22, 1
bne $22, $24, nothreeofakind
add $17, $17, $13
add $17, $17, $13
add $17, $17, $13
nothreeofakind: nop

j nextturn

# 4 of a kind selected
hand7: nop

add $22, $0, $0		# how many are like me?
#add $23, $0, $0		# what value is this three of a kind?
addi $24, $0, 3		# what we're looking for

#check dice 1 and 2
bne $11, $12, check13
addi $22, $22, 1	# dice one and two are the same! we have TWO of a kind

check13: nop
bne $11, $13, check14
addi $22, $22, 1
bne $22, $24, check14
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn
check14: nop
bne $11, $14, check15
addi $22, $22, 1
bne $22, $24, check15
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn
check15: nop
bne $11, $15, check23
addi $22, $22, 1
bne $22, $24, check23
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
add $17, $17, $11
j nextturn

check23: nop
add $22, $0, $0
bne $12, $13, check24
addi $22, $22, 1
bne $22, $24, check24
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
j nextturn
check24: nop
bne $12, $14, check25
addi $22, $22, 1
bne $22, $24, check25
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
j nextturn
check25: nop
bne $12, $15, nofourofakind
addi $22, $22, 1
bne $22, $24, nofourofakind
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
add $17, $17, $12
nofourofakind: nop

j nextturn

# Full house selected
hand8: nop
add $22, $0, $0
add $23, $0, $0
addi $24, $0, 1
addi $25, $0, 0

add $22, $11, $0
j find23

comeback: nop
bne $22, $12, whytf
addi $24, $24, 1
j checkthird

whytf: nop
add $25, $25, 1
j checkthird

find23: nop
bne $22, $12, found1
bne $22, $13, found2
bne $22, $14, found3
bne $22, $15, found4
j howrude

found1: nop
add $23, $12, $0
j comeback

found2: nop
add $23, $13, $0
j comeback

found3: nop
add $23, $14, $0
j comeback

found4: nop
add $23, $15, $0
j comeback

checkthird: nop
bne $22, $13, doesntmatchfirst1
addi $24, $24, 1
j checkfourth

checkfourth: nop
bne $22, $14, doesntmatchfirst2
addi $24, $24, 1
j checkfifth

checkfifth: nop
bne $22, $15, doesntmatchfirst3
addi $24, $24, 1
j endoffullhouse

doesntmatchfirst1: nop
bne $23, $13, howrude
addi $25, $25, 1
j checkfourth

doesntmatchfirst2: nop
bne $23, $14, howrude
addi $25, $25, 1
j checkfifth

doesntmatchfirst3: nop
bne $23, $15, howrude
addi $25, $25, 1
j endoffullhouse

endoffullhouse: nop
addi $22, $0, 2
addi $23, $0, 3
bne $24, $22, is24equalto3		# 24 is not 2
bne $25, $23, howrude
j success

is24equalto3: nop
bne $24, $23, howrude
j is25equalto2

is25equalto2: nop
bne $25, $22, howrude
j success

success: nop
addi $17, $17, 25
j nextturn

howrude: nop
j nextturn

# Small straight selected
hand9: nop

j nextturn

# Large straight
hand10: nop
addi $23 $0 1
add $24 $0 $0

## Find 1
bne $11 $23 r1not1
addi $24 $0 1
j find2
r1not1: bne $12 $23 r2not1
addi $24 $24 1
j find2
r2not1: bne $13 $23 r3not1
addi $24 $24 1
j find2
r3not1: bne $14 $23 r4not1
addi $24 $24 1
j find2
r4not1: bne $15 $23 find2
addi $24 $24 1
j find2

find2: addi $23 $0 2
bne $11 $23 r1not2
addi $24 $24 1
j find3
r1not2: bne $12 $23 r2not2
addi $24 $24 1
j find3
r2not2: bne $13 $23 r3not2
addi $24 $24 1
j find3
r3not2: bne $14 $23 r4not2
addi $24 $24 1
j find3
r4not2: bne $15 $23 nextturn
addi $24 $24 1
j find3

find3: addi $23 $0 3
bne $11 $23 r1not3
addi $24 $24 1
j find4
r1not3: bne $12 $23 r2not3
addi $24 $24 1
j find4
r2not3: bne $13 $23 r3not3
addi $24 $24 1
j find4
r3not3: bne $14 $23 r4not3
addi $24 $24 1
j find4
r4not3: bne $15 $23 nextturn
addi $24 $24 1
j find4

find4: addi $23 $0 4
bne $11 $23 r1not4
addi $24 $24 1
j find5
r1not4: bne $12 $23 r2not4
addi $24 $24 1
j find5
r2not4: bne $13 $23 r3not4
addi $24 $24 1
j find5
r3not4: bne $14 $23 r4not4
addi $24 $24 1
j find5
r4not4: bne $15 $23 nextturn
addi $24 $24 1
j find5

find5: addi $23 $0 5
bne $11 $23 r1not5
addi $24 $24 1
blt $24 $23 find6
j addscore5
r1not5: bne $12 $23 r2not5
addi $24 $24 1
blt $24 $23 find6
j addscore5
r2not5: bne $13 $23 r3not5
addi $24 $24 1
blt $24 $23 find6
j addscore5
r3not5: bne $14 $23 r4not5
addi $24 $24 1
blt $24 $23 find6
j addscore5
r4not5: bne $15 $23 nextturn
addi $24 $24 1
blt $24 $23 find6
j addscore5

find6: addi $23 $0 6
bne $11 $23 r1not6
addi $24 $24 1
j addscore6
r1not6: bne $12 $23 r2not6
addi $24 $24 1
j addscore6
r2not6: bne $13 $23 r3not6
addi $24 $24 1
j addscore6
r3not6: bne $14 $23 r4not6
addi $24 $24 1
j addscore6
r4not6: bne $14 $23 nextturn
addi $24 $24 1
j addscore6

addscore5: addi $17 $17 30
j nextturn
addscore6: addi $17 $17 40
j nextturn

# chance
hand11: nop
add $17 $17 $11
add $17 $17 $12
add $17 $17 $13
add $17 $17 $14
add $17 $17 $15
j nextturn

# yahtzee
hand12: nop
bne $11 $12 notequal
nop
bne $11 $13 notequal
nop
bne $11 $14 notequal
nop
bne $11 $15 notequal
addi $17 $17 50
j nextturn
notequal: nop
j nextturn


####################### SCREEN PREPARATION FUNCTIONS ############################

##### All screen preparation functions stall until button is depressed

#
# function that clears registers and loads start screen upon jumping from
# one screen back to start before actually jumping to start loop
#
prepstart: nop
addi $27 $27 1
bne $27 $31 prepstart
add $27 $0 $0
bne $1 $0 prepstart
nop
nop
nop
bne $4 $0 prepstart
nop
add $30 $0 $0
# prep code
j start # return to start screen after clearing registers

#
# function that clears registers and loads leaderboard screen upon jumping to
# leaderboard before actually jumping to leaderboard loop
#
prepleader: nop
addi $27 $27 1
bne $27 $31 prepleader
add $27 $0 $0
bne $2 $0 prepleader
addi $30 $0 2
# prep code
j leaderboard # jump to leaderboard after clearing registers

#
# function for clearing registers and loading game settings screen after jumping
# from start but before game
#
prepgamesetting: nop
addi $27 $27 1
bne $27 $31 prepgamesetting
add $27 $0 $0
bne $1 $0 prepgamesetting
addi $30 $0 1
# prep code
j gamesetting # jump to game setting screen

##### Prep single player, multiplayer, and cpu will all be same but with different registers
prepsingleplayer: nop
bne $1 $0 prepsingleplayer
# set screen register, clear dice registers
addi $30 $0 3
add $11 $0 $0
add $12 $0 $0
add $13 $0 $0
add $14 $0 $0
add $15 $0 $0
addi $19 $0 3
addi $20 $0 0
nop
j singlegame

prepmultiplayer: nop
bne $2 $0 prepmultiplayer
addi $30 $0 3
nop
j multiplayer

prepcpu: nop
addi $10 $0 1
bne $3 $0 prepcpu
addi $30 $0 3
add $18 $0 $0
nop
j cpugame

nextturn: nop
addi $19 $0 3
add $11 $0 $0
add $12 $0 $0
add $13 $0 $0
add $14 $0 $0
add $15 $0 $0
bne $0 $10 checkcpu # if is a cpu game
j singlegame
checkcpu: nop
addi $25 $0 1
nop
nop
nop
bne $10 $25 cpugamefromsingle
nop
# addi $10 $0 2 # $10 = 2
j singlegamefromcpu
# j singlegame

singlegamefromcpu: nop
sw $17 2($0)
sw $18 3($0)
nop
addi $10 $0 2
nop
lw $17 1($0)
j singlegame

cpugamefromsingle: nop
sw $17 1($0)
nop
addi $10 $0 1
nop
lw $17 2($0)
lw $18 3($0)
j cpugame

########## CPU FUNCTIONS ###############
cpuroll: nop
add $11 $0 $29
addi $23 $0 462
addi $24 $0 1
wait1: addi $24 $24 1
nop
bne $24 $23 wait1
add $12 $0 $29
addi $23 $0 343
addi $24 $0 1
wait2: addi $24 $24 1
nop
bne $24 $23 wait2
add $13 $0 $29
addi $23 $0 681
addi $24 $0 1
wait3: addi $24 $24 1
nop
bne $24 $23 wait3
add $14 $0 $29
addi $23 $0 82
addi $24 $0 1
wait4: addi $24 $24 1
nop
bne $24 $23 wait4
add $15 $0 $29
addi $24 $0 50000
add $24 $24 $24
add $24 $24 $24
add $24 $24 $24
add $24 $24 $24
add $24 $24 $24
add $24 $24 $24
addi $23 $0 1
stallcpu: addi $23 $23 1
nop
bne $23 $24 stallcpu
j cpuafterroll

cpuafterroll: nop
bne $18 $0 cpuhand1
addi $18 $18 1
j hand0
cpuhand1: nop
addi $24 $0 1
bne $18 $24 cpuhand2
addi $18 $18 1
j hand1
cpuhand2: nop
addi $24 $0 2
bne $18 $24 cpuhand3
addi $18 $18 1
j hand2
cpuhand3: nop
addi $24 $0 3
bne $18 $24 cpuhand4
addi $18 $18 1
j hand3
cpuhand4: nop
addi $24 $0 4
bne $18 $24 cpuhand5
addi $18 $18 1
j hand4
cpuhand5: nop
addi $24 $0 5
bne $18 $24 cpuhand6
addi $18 $18 1
j hand5
cpuhand6: nop
addi $24 $0 6
bne $18 $24 cpuhand7
addi $18 $18 1
j hand6
cpuhand7: nop
addi $24 $0 7
bne $18 $24 cpuhand8
addi $18 $18 1
j hand7
cpuhand8: nop
addi $24 $0 8
bne $18 $24 cpuhand9
addi $18 $18 1
j hand8
cpuhand9: nop
addi $24 $0 9
bne $18 $24 cpuhand10
addi $18 $18 1
j hand9
cpuhand10: nop
addi $24 $0 10
bne $18 $24 cpuhand11
addi $18 $18 1
j hand10
cpuhand11: nop
addi $24 $0 11
bne $18 $24 hand12
addi $18 $18 1
j hand11
