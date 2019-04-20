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
# TODO Figure out how to interface buttons with registers
bne $1 $0 prepgamesetting # if $1 gets toggled, jump to function for prepping game settings screen
nop
bne $2 $0 prepleader # if $2 gets toggled by selecting leaderboard, jump to function for prepping the screen

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
bne $2 $0 prepmultiplayer # $2 toggle multiplayer game
bne $3 $0 prepcpu # $3 toggles cpu game
bne $4 $0 prepstart # $4 is back to start
nop
j gamesetting # If no options are chosen, return to start of loop

####################### GAME MODES #############################################

##### Game rules
# $1 assigned to hold die 1
# $2 assigned to hold die 2
# $3 assigned to hold die 3
# $4 assigned to hold die 4
# $5 assigned to hold die 5 TODO make reg 5 asynchronous in regfile
# $6 assigned to select left TODO make reg 6 asynchronous
# $7 assigned to select right TODO make reg 7 asynchronous
# $8 assigned to enter button TODO make reg 8 asynchronous
# $9 assigned to roll button TODO make reg 9
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
#
# All button toggles have event handlers, which are specified in GAME FUNCTIONS
#
singlegame: nop
bne $9 $0 doroll # Branch if roll is performed
j singlegame

cpugame: nop

j cpugame

multiplayer: nop

j multiplayer

####################### GAME FUNCTIONS #########################################

# Roll remaining dice
doroll: nop
bne $9 $0 doroll
nop
j singlegame


####################### SCREEN PREPARATION FUNCTIONS ############################

##### All screen preparation functions stall until button is depressed

#
# function that clears registers and loads start screen upon jumping from
# one screen back to start before actually jumping to start loop
#
prepstart: nop
bne $1 $0 prepstart
bne $4 $0 prepstart
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
addi $30 $0 3
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
