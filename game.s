#
#
#
#
#
#
#
#
#
#
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

j gamesetting # If no options are chosen, return to start of loop

####################### GAME MODES #############################################

singlegame: nop

j singlegame

cpugame: nop

j cpugame

multiplayer: nop

j multiplayer

####################### GAME FUNCTIONS #########################################




####################### SCREEN PREPARATION FUNCTIONS ############################

#
# function that clears registers and loads start screen upon jumping from
# one screen back to start before actually jumping to start
#
prepstart: nop

j start # return to start screen after clearing registers

#
# function that clears registers and loads leaderboard screen upon jumping to
# leaderboard before actually jumping to leaderboard
#
prepleader: nop

j leaderboard # jump to leaderboard after clearing registers

#
# function for clearing registers and loading game settings screen after jumping
# from start but before game
#
prepgamesetting: nop

j gamesetting # jump to game setting screen
