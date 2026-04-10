extends _Peekaboo_Script
class_name _Peekaboo_Common_Script_Ghost

@export var movement : Array[Vector2i] = []

func _on_scene_start():
	if movement == []:
		return
		
	var vector : Vector2i
	while true:
		vector = movement.pop_front()
		movement.append(vector)
		
		await mover.face(vector).move(vector)
		await mover.wait(1.0)
		
