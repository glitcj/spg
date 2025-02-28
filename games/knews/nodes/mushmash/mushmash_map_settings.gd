extends Node
class_name MushMashMapSettings

var height: int = 5
var width: int = 5

# var turn_cell_selection_type = 

enum CellMovementType {Instant, Linear}
var cell_movement_type = CellMovementType.Linear


var mushroom_template = preload("res://games/knews/nodes/mushmash/node.mushmash.mushroom.tscn")
var flower_template = preload("res://games/knews/nodes/mushmash/node.mushmash.flower.tscn")
var wall_template = preload("res://games/knews/nodes/mushmash/node.mushmash.wall.tscn")
var base_cell_template = preload("res://games/knews/nodes/mushmash/node.mushmash.cell.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
