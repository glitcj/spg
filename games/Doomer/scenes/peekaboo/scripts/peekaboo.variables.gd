@tool # This allows the static logic to run safely in the editor
extends Node
class_name _Peekaboo_Variables



static var l1_entry_position = Vector2i(1, 3)
static var l2_entry_position = Vector2i(-19, -5)
static var l3_entry_position = Vector2i(-20, 20)
static var l4_entry_position = Vector2i(19, 3)



static var l1_camera_position = Vector2i(0, 0)
static var l2_camera_position = Vector2i(-19, -5)
static var l3_camera_position = Vector2i(-20, 20)
static var l4_camera_position = Vector2i(19, 0)


static var l1_enemies_count = 0
static var l2_enemies_count = 0
static var l3_enemies_count = 0
static var l4_enemies_count = 0




enum Keys {l1_1_enemies_count, l2_1_enemies_count}
static var all: Dictionary = {} # Explicitly type it

static func initialise_variables():
	# Ensure the dictionary exists before looping
	if all == null:
		all = {}
		
	for k in Keys.values():
		all[k] = 0
	
	print("Peekaboo Variables: Initialized successfully.")
