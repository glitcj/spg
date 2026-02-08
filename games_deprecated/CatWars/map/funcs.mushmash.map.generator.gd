extends Node
class_name _MushMash_Map_Generator

@onready var mushmash = get_parent().get_parent()

@onready var map = get_parent()

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


func print_position_indexed_cells_map():
	print("Cells Map")
	for j in map.position_indexed_cells_map.keys(): # range(constants.height):
		var line = ""
		for i in map.position_indexed_cells_map[j].keys(): # range(constants.height):
			var cell: MushMashCell = map.position_indexed_cells_map[j][i]
			if cell != null:
				line = line + str(cell.map_position.x) + "," + str(cell.map_position.y) + "   "
			else:
				line = line + "null" + "   "
		print(line)

		
func print_uuid_map(max_uuid_digits: int = 4):
	print("UUID Map")
	for j in map.position_indexed_cells_map.keys(): # range(constants.height):
		var line = ""
		for i in map.position_indexed_cells_map[j].keys(): # range(constants.height):
			if map.position_indexed_cells_map[j][i]:
				line = line + map.position_indexed_cells_map[j][i].uuid.substr(0,max_uuid_digits) + "   "
			else:
				line = line + "null" + "   "
		print(line)


func _update_position_indexed_cells_map():
	var new_position_indexed_cells_map: Dictionary = {}
	for cell in mushmash._get_all_cells():
		if cell.new_map_position.y not in new_position_indexed_cells_map.keys():
			new_position_indexed_cells_map[cell.new_map_position.y] = {}
		new_position_indexed_cells_map[cell.new_map_position.y][cell.new_map_position.x] = cell
	mushmash.map.position_indexed_cells_map = new_position_indexed_cells_map
