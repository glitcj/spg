extends Node


# TODO:
# Check taps/flops the gun, call loads the gun, then a duel with minions
# Gun shots head shot 2D highly detailed kojimaesque mechanics
#　https://www.google.com/search?q=godot+can+i+speed+up+gameplay&oq=godot+can+i+speed+up+gameplay&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRigAdIBCDQ4MDhqMGo3qAIIsAIB8QXkRqlx1t96SfEF5Eapcdbfekk&sourceid=chrome&ie=UTF-8#fpstate=ive&vld=cid:197e56f7,vid:wWq0u-0O-lU,st:39




# - - - - Concept : Phantasmo Poker - - - - - 

# Map has procedurally generated 5 players
# Player has Traits book like Phantasmophobia
# Has trait descriptions:
# The caller: Will call every hand you have
# The starer
# The Sweater
# The Lookawayer
# The Joker: Cracks a joke whenever they have a good hand, watch out !
# Player can perform an Insight each game, declaring that the enemy has a particualr Trait
# Purpose of game is correctly guess all the Traits of all the enemies on the map
# The score is how many mistakes the player makes and how good they are at Poker
# The book also a reference for some special "Boss" characters, the quickerr the player finds them and beats them the better
# The game is fun because:
# Drives completion reward
# Fun to guess Traits
# Very replayable to maximise score and challenge how quick you can guess Traits
# Traits are visual and funny
# Doesnt have a lot of dialogue
# Player gradually learns how to use their Items to detect Traits quickly
# For example, The High Caller trait means the enemy ALWAYS calls when a high Ace card is on the Table
# So the player can use the Shape Shifter item ability to place a high card on the Table, an quickly catches the Trait
# Has very Heavy and Weighty animations
# The more traits a player discovers WITHOUT using insight ability, he can use the insight ability more
# The Player needs to discover the boss before they discover him, or else he is killed, its kill or be killed

# The player learns abilities to help him detect traits the more traits he learns
# For example, when the player detects the high caller ability, he will learn the ability Shape Shifter that allows him to increase the value of a card to Ace


# ---- Concept ----
# Each enemy has TELLS and TRAITS
# Tells are VISUAL, they look left before they call
# Traits are PATTERNS and ITEMS special abilities
# Enemies will make comments
# Player tries to guess the Ghost type to win
# Character faces are like phoenix right
# Player has many special abilities
# Tells - Traits combos and Enemies can be PROCEDURALLY generated
# Combinations will automatically scale the game
