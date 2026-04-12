@tool # This allows the static logic to run safely in the editor
extends Node
class_name _Peekaboo_Variables


static var l1_enemies_count = 0
static var l2_enemies_count = 0
static var l3_enemies_count = 0
static var l4_enemies_count = 0




# enum Keys {l1_1_enemies_count, l2_1_enemies_count}
# static var all: Dictionary = {} # Explicitly type it


"""
static func initialise_variables():
	# Ensure the dictionary exists before looping
	if all == null:
		all = {}
		
	for k in Keys.values():
		all[k] = 0
	
	print("Peekaboo Variables: Initialized successfully.")
"""
