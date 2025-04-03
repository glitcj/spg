extends Node
class_name _MushMash_Map_Generator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func sample_map_1():
	var sample: Array = [
		[0,1,1,1,0],
		[1,0,2,0,1],
		[0,1,2,1,0],
		[1,0,2,0,1],
		[0,1,1,1,0]
		]
	return sample



func sample_map_3():
	var sample: Array = [
		[0,1,1,1,0,0,0,0],
		[1,0,2,0,1,0,0,0],
		[0,1,2,1,0,0,0,0],
		[1,0,2,0,1,0,0,0],
		[0,1,1,1,0,0,0,0]
		]
	return sample


func sample_map_4():
	var sample: Array = [
		[0,0,1,0,0,0,0,0],
		[1,0,0,0,0,0,0,0],
		[0,1,2,0,0,0,0,0],
		[1,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0]
		]
	return sample

func sample_map_2():
	var sample: Array = [
		[0,1,1,1,1],
		[0,0,0,0,0],
		[0,1,1,1,1],
		[0,0,0,0,0],
		[0,1,1,1,1]
		]
	return sample
