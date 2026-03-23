extends Node
class_name _Peekaboo_Lambdas

@export var doomer : _Doomer

func get_peekaboo(): return find_parent("_PeekaBoo") as _PeekaBoo
func get_map(): return find_parent("_Peekaboo_Map") as _Peekaboo_Map
func get_player(): return find_parent("_Peekaboo_Map").find_child("Player") as _PeekaBoo_Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func transport_player(position: Vector2i):
	var mover = get_player().find_child("_Peekaboo_Mover") as _Peekaboo_Mover
	mover.map_position = position
