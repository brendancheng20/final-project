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
# $16 assigned to which hand is selected (i.e. 3 of a kind, etc.)
# $17 assigned to total score
# $18 index for array value in memory that stores whether or not the hand has
#     been selected
# $19 assigned to number of rolls taken this turn
#
# $29 = random value for die
#
# All button toggles have event handlers, which are specified in GAME FUNCTIONS
#
singlegame: nop
# roll
# bne $9 $0 doroll # Branch if roll is to be performed
bne $19 $0 checkhold
j singlegame
afterroll: nop
# Now check for dice to be held - only if still rolls left
bne $19 $0 checkhold
bne $8 $0 nextturn
j afterroll

cpugame: nop

j cpugame

multiplayer: nop

j multiplayer

####################### GAME FUNCTIONS #########################################

##### Roll functions
# Roll remaining dice
doroll: nop
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
j checkhold

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
checkhold: nop
bne $9 $0 doroll # if a roll is to be taken, go for it
nop
# Clear registers if hold button is touched
bne $1 $0 hold1
nop
nop
nop
bne $2 $0 hold2
nop
nop
nop
bne $3 $0 hold3
nop
nop
nop
bne $4 $0 hold4
nop
nop
nop
bne $5 $0 hold5
nop
nop
nop
j checkhold

hold1: nop
bne $1 $0 hold1
add $11 $0 $0
nop
j checkhold

hold2: nop
bne $2 $0 hold2
add $12 $0 $0
nop
j checkhold

hold3: nop
bne $3 $0 hold3
add $13 $0 $0
nop
j checkhold

hold4: nop
bne $4 $0 hold4
add $14 $0 $0
nop
j checkhold

hold5: nop
bne $5 $0 hold5
add $15 $0 $0
nop
j checkhold


####################### SCREEN PREPARATION FUNCTIONS ############################

##### All screen preparation functions stall until button is depressed

#
# function that clears registers and loads start screen upon jumping from
# one screen back to start before actually jumping to start loop
#
prepstart: nop
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
bne $2 $0 prepleader
addi $30 $0 2
# prep code
j leaderboard # jump to leaderboard after clearing registers

#
# function for clearing registers and loading game settings screen after jumping
# from start but before game
#
prepgamesetting: nop
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
bne $8 $0 nextturn
addi $19 $0 3
add $11 $0 $0
add $12 $0 $0
add $13 $0 $0
add $14 $0 $0
add $15 $0 $0
j singlegame
