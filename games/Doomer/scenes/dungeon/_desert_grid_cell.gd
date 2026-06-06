@tool
extends Area3D
class_name _Desert_Grid_Cell



@export_enum("floor","wall","event") var type = "floor":
	set(value):
		type = value
		_update_cell()
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _update_cell():
	if type == "floor": pass
	if type == "wall": %"RigidBody3D Wall".visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
