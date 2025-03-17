extends Node


enum lTags {Node_Status_MB}

var lID: Dictionary = {
	lTags.Node_Status_MB: Variables.generate_uuid(),
}




enum CellMovementType {Instant, Linear}
var cell_movement_type = CellMovementType.Linear


var base_cell_template = preload("res://games/knews/nodes/CatWars/cell/node.catwars.cell.tscn")


var max_nodes = 1000
var cell_step_x = 200
var cell_step_y = 200

# TODO: Each position has a coloured animated canvas
# UUIDs pointing to nodes
var lID_Map_Cells: Dictionary
var status_message_box_settings: MessageBoxSettings =  MessageBoxSettings.new()

var DEBUG = true
var ENABLE_LOOP = true

func _ready():
	_initialise_map_cell_uuids()
	_set_statush_message_box()

func _initialise_map_cell_uuids():
	for j in range(max_nodes):
		for i in range(max_nodes):
			lID_Map_Cells[j * max_nodes + i] = Variables.generate_uuid()
			
func get_cell_uuid(i, j):
	return lID_Map_Cells[j * max_nodes + i]

func _set_statush_message_box():
	status_message_box_settings.is_autoplay = true
	status_message_box_settings.is_detached = false
	status_message_box_settings.autoplay_wait_seconds = 1
	
