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

j cpugame

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
bne $19 $0 dohold1 # If hold is allowed
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
bne $19 $0 dohold1 # If hold is allowed
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

j nextturn

# Twos hand selected
hand1: nop

j nextturn

# Threes hand selected
hand2: nop

j nextturn

# Fours hand selected
hand3: nop

j nextturn

# Fives hand selected
hand4: nop

j nextturn

# Sixes hand selected
hand5: nop

j nextturn

# 3 of a kind
hand6: nop

j nextturn

# 4 of a kind selected
hand7: nop

j nextturn

# Full house selected
hand8: nop

j nextturn

# Small straight selected
hand9: nop

j nextturn

# Large straight
hand10: nop

j nextturn

# chance
hand11: nop

j nextturn

# yahtzee
hand12: nop

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
addi $20 $0 -1
nop
j singlegame

prepmultiplayer: nop
bne $2 $0 prepmultiplayer
addi $30 $0 3
nop
j multiplayer

prepcpu: nop
bne $3 $0 prepcpu
addi $30 $0 3
nop
j cpugame

nextturn: nop
addi $19 $0 3
add $11 $0 $0
add $12 $0 $0
add $13 $0 $0
add $14 $0 $0
add $15 $0 $0
j singlegame
