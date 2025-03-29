extends Node2D
class_name _MushMash

# TODO: Add Birds
# TODO: Add fat birds (Fat chickens that block movement)
# TODO: Add Sky Parallex background
# TODO: Add cell selection in player turn

# TODO: Move TurnController funcs to a separate node TurnController
# TODO: Refactor Mushmash into many composite nodes
# TODO: Add ninja sprite parsing

# TODO: This should be used only once to initialise map
var cells_map_initialiser: Array

# var settings: MushMashMapSettings
var cells_map: Dictionary
var uuid_map := {}

enum Direction {Up, Down, Left, Right}
var DirectionVector := {
	Direction.Up: Vector2i(0, 1),
	Direction.Down: Vector2i(0, -1),
	Direction.Left: Vector2i(1, 0),
	Direction.Right: Vector2i(-1, 0),
	
}

# Set references so all components can talk to each other
@onready var camera: Camera2D = $Camera2D
@onready var turner: _MushMash_Turner = $Turner
@onready var map : _MushMash_Map = $Map
@onready var input_handles : _MushMash_InputHandles = $InputHandles
@onready var ai : _MushMash_AI  = $AI

@onready var hud_face: Sprite2D = $HudCanvasLayer/Hud/Face
@onready var hud: _Mushmash_HUD = $HudCanvasLayer/Hud
@onready var log := hud.log
@onready var tilemap: TileMapLayer = $Map/TileMapLayerMain
@onready var on_map_cells: Array = $Map/OnMapNodes.get_children()
@onready var player: MushMashCell = $Map/OnMapNodes/Player

@onready var constants = $Constants
@onready var settings: MushMashMapSettings = $Constants # Deprecate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cells_map_initialiser = map.sample_map_4()
	
	cells_map = map.get_cells_in_tilemap()
	print(constants.height)
	print(constants.width)
	$Turner._initialise_player_cells_turn_queue()
	$Turner._initialise_opponent_cells_turn_queue()	
	
	absolute_resize_tilemap()
	
func _initialise_uuid_map():
	for j in constants.height:
		for i in constants.width:
			uuid_map[j * constants.height + i] = _MushMash_Constants.get_cell_uuid(i, j)

func _initialise_cells_map():
	pass

func _get_uuid(x, y):
	return uuid_map[y * constants.height + x]

func _input(event):
	$InputHandles.handle_inputs(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_map()
	_update_console()
	_update_camera()

func _update_camera():
	$Camera2D.position = $Map/OnMapNodes/Player.position

func _update_console():
	var O_O_ = ""
	for cell: MushMashCell in $Turner.player_cells_turn_queue:
		O_O_ = O_O_ + "%s\t" % cell.uuid.substr(0,6)
	
	$Console.text = ""
	
func initialise_random_map():
	cells_map_initialiser = []
	var row
	for i in range(constants.height):
		row = []
		for j in range(constants.width):
			row.append(0)
		cells_map_initialiser.append(row)
	return cells_map_initialiser

func draw_cells():
	var uuid	
	for j in range(constants.height):
		for i in range(constants.width):
			if cells_map_initialiser[j][i] > 0:
				var cell: MushMashCell = cells_map[j][i]
				cell.position = Vector2(150 * i, 150 * j)
				push_error(get_parent().name)
				$GridOrigin.add_child(cell)
				
				cell.animation_player.play("Idle")

func _update_map():
	var all_cells = _get_all_cells()
	var destination
	var direction
	for cell: MushMashCell in all_cells:
		destination = map.get_tilemap_cell_position(cell.x, cell.y)
		if constants.cell_movement_type == constants.CellMovementType.Instant:
			cell.position = destination

		elif constants.cell_movement_type == constants.CellMovementType.Linear:
			if destination != cell.position:
				direction = (destination - cell.position).normalized()
				cell.position = cell.position + 5 * direction

func _update_new_positions(cells, direction: int):
	if true:
		print("\n\n----- Old Maps ------")
		print_cells_map()
		print_uuid_map()	
		pass
		
		var x = 0
	
	for cell in cells:
		if not cell.is_movable:
			continue
			
		var i = cell.x
		var j = cell.y
		

		if direction == Direction.Down:
			_update_single_cell(cell, i, j + 1)

		elif direction == Direction.Up:
			_update_single_cell(cell, i, j - 1)
			
		elif direction == Direction.Left:
			_update_single_cell(cell, i - 1, j)
			
		elif direction == Direction.Right:
			_update_single_cell(cell, i + 1, j)

	map._resolve_cell_collisions()


func _update_new_positions_v1(direction: int):
	if true:
		print("\n\n----- Old Maps ------")
		print_cells_map()
		print_uuid_map()	
		pass
		
		var x = 0
	
	for cell in _get_all_cells():
		if not cell.is_movable:
			continue
			
		var i = cell.x
		var j = cell.y
		

		if direction == Direction.Down:
			_update_single_cell(cell, i, j + 1)

		elif direction == Direction.Up:
			_update_single_cell(cell, i, j - 1)
			
		elif direction == Direction.Left:
			_update_single_cell(cell, i - 1, j)
			
		elif direction == Direction.Right:
			_update_single_cell(cell, i + 1, j)

	map._resolve_cell_collisions()




func _on_cell_positions_changed():
	pass

func _update_single_cell(cell, new_x, new_y):
	cell.new_map_position = Vector2i(new_x, new_y)
	cell.new_x = new_x
	cell.new_y = new_y

func _update_cells_map():
	var all_cells = _get_all_cells()
	for cell: MushMashCell in all_cells:
		if cell.new_x != cell.x:
			cell.x = cell.new_x
		if cell.new_y != cell.y:
			cell.y = cell.new_y

	var new_cells_map: Dictionary = {}
	for cell in _get_all_cells():
		if cell.new_y not in new_cells_map.keys():
			new_cells_map[cell.new_y] = {}
		new_cells_map[cell.new_y][cell.new_x] = cell
	cells_map = new_cells_map
	
	if false:
		print("\n\n----- New Maps ------")
		print_cells_map()
		print_uuid_map()	

func _get_all_cells():
	var all_cells = []
	
	for j in cells_map.keys():
		for i in cells_map[j].keys():
			if cells_map[j][i] != null:
				all_cells.append(cells_map[j][i])
	return all_cells



func _get_all_typed_cells(types: Array = [MushMashCell.CellTypes.Player]):
	var all_cells = []
	for j in cells_map.keys():
		for i in cells_map[j].keys():
			var cell: MushMashCell = cells_map[j][i]
			if cell != null and cell.type in types:
				all_cells.append(cells_map[j][i])
	return all_cells


func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell)
	
func print_cells_map():
	print("Cells Map")
	for j in cells_map.keys(): # range(constants.height):
		var line = ""
		for i in cells_map[j].keys(): # range(constants.height):
			var cell: MushMashCell = cells_map[j][i]
			if cell != null:
				line = line + str(cell.x) + "," + str(cell.y) + "   "
			else:
				line = line + "null" + "   "
		print(line)

		
func print_uuid_map(max_uuid_digits: int = 4):
	print("UUID Map")
	for j in cells_map.keys(): # range(constants.height):
		var line = ""
		for i in cells_map[j].keys(): # range(constants.height):
			if cells_map[j][i]:
				line = line + cells_map[j][i].uuid.substr(0,max_uuid_digits) + "   "
			else:
				line = line + "null" + "   "
		print(line)



func absolute_resize_tilemap(resize_width = 80, resize_height = 80):
	var tileset: TileSet = $Map/TileMapLayerMain.tile_set
	var scaler = resize_width/tileset.tile_size.x
	
	$Map.scale = Vector2(scaler, scaler)
	
func place_cells_on_tile_map():
	pass
