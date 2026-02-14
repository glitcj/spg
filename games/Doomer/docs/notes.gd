extends Node


"""
how about if i make it a normal poker game, but the winners win more the more they won, meaning their blind grows as a function of how much they win, would the performance delta grow between random players and informed players ? Thats what i mean by a simple change to poker
In short: Yes, the delta would grow exponentially.
By making the blinds a function of a player's winnings (a "Progressive Blind" system), you are effectively adding a compounding multiplier to skill. In a normal game, the blinds stay flat, meaning a pro beats a random player at a linear rate. In your version, the pro’s edge accelerates.
1. The "Rich Get Richer" Feedback Loop
In standard poker, if an informed player wins 100 chips, the next hand still costs the same 1/2 chip blinds. In your game, if the pro wins, their "cost of entry" increases, but so does the pot size they can generate.
The Informed Player uses this to "snowball." Since they have a higher Win Rate (bb/100), they will reach higher blind levels faster, winning massive pots while the random player is stuck playing for "pennies."
2. Punishing Random Mistakes
Random players make frequent mathematical errors (e.g., calling with bad Pot Odds).
The Delta: In your game, a random player’s mistake at a high blind level is catastrophic. An informed player will wait for the random player to reach a high "won amount" (and thus high blinds), then "trap" them. The loss for the random player isn't just a flat amount; it’s a percentage of their entire successful run.
3. Forced Aggression (The Skill Ceiling)
As blinds grow, the M-ratio (the ratio of your stack to the cost of one orbit) drops.
Random Player: Usually plays too "passive." High blinds force them to bleed chips until they are forced to go "all-in" with random cards.
Informed Player: Understands Push/Fold Charts and knows exactly when the math dictates an all-in. The skill delta here is the difference between "guessing" when to shove and "knowing" the mathematical threshold.
The Mathematical Result
If Player A has a 5% edge over Player B:
Standard Poker: Player A wins 5% more money over time.
Your Game: Player A wins 5% more money, which increases their blinds, which increases the pot sizes they win, leading to geometric growth of their lead.
Warning for Game Design: This mechanic creates a "runaway leader" problem. Once a skilled player gets ahead, the random player mathematically cannot catch up because the pro is playing for much larger stakes.
Do you want to balance this by making the high-blind player take more risk, or do you want the game to end quickly once a "boss" emerges at the table?
"""








# TODO:
# TOP PRIORITY:  Each Card hit makes both faces animate a random 
# happiness hitting and sadness getting hit in a random direction
#  face

# TOP PRIORITY: Characters are parodies of existing popular personalities
# Eg., Alex Jones, Joe Rogan, Nick Fuentes, Winston Churchil
# A la the alex jones game



# TOP PRIORITY: Add opponent inscryption like map, showing
# Opponents and their traits
# Each time opponent an opponent is FOKED they get a PFOKED 
# Stamp on their face




# Gun duel: On direction tap pushes a flying cursor in the riection then trigger to shoot
# Opponent gets an evade chance by also pushing a flying cursor, 
# if they reach within an errored area of the opponents aim shot
# They can parry and reduce damage
# This duel happens at the end for a chance to a second wind ?


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

# The game will show the players own traits over time, probability of playing ace cards etc

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
