extends Node


"""
# Gameplay loop

. Enemy Map / Showing Traits and guns
. Poker Round
. Reach boss
. Score is accumilated coins

# Poker round loop
1. Forward = confirm move (bet)
2. Back = load gun (put coins into gun)
3. Check is simply goin forward
4. bet = back count fibonacci or power of AVAILABLE coins, 5 > 10 > 25 > 50 > 100
"""


# Always good to have nodes live inside a margin > center container
# This allow the handling of object mirroring and proper scaling easier

# await get_tree().process_frame # Waits one frame
