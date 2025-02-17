extends Node
class_name MushMashMapSettings


var height: int = 5
var width: int = 5


enum CellMovementType {Instant, Linear}
var cell_movement_type = CellMovementType.Instant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
