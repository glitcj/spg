extends Node
# class_name _Peekaboo_Script


var parent : RigidBody2D
var mover : _Peekaboo_Mover

func _ready():
	_get_components.call_deferred()
	_run_script.call_deferred()


func _get_components():
	parent = get_parent()
	assert(parent.find_children("*", "_Peekaboo_Mover").size() > 0)
	mover = parent.find_child("_Peekaboo_Mover")

func _run_script():
	while true:
		mover.move(parent.position + Vector2(0, 300))
		await mover.finished_movement
		mover.move(parent.position + Vector2(0, -500))
		await mover.finished_movement
