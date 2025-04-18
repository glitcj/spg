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
var position_indexed_cells_map_initialiser: Array


# Set references so all components can talk to each other
@onready var camera: Camera2D = $Camera2D
@onready var turner: _MushMash_Turner = $Turner
@onready var map : _MushMash_Map = $Map
@onready var map_main : TileMapLayer = $Map/TileMapLayerMain
@onready var input_handles : _MushMash_Map_Handler = $InputHandles
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
	
	# refactor
	map.position_indexed_cells_map = map.place_and_correct_on_map_cells()
	print(constants.height)
	print(constants.width)
	$Turner._initialise_player_cells_turn_queue()
	$Turner._initialise_opponent_cells_turn_queue()	
	
	absolute_resize_tilemap()
	
func _initialise_uuid_map():
	for j in constants.height:
		for i in constants.width:
			map.uuid_map[j * constants.height + i] = _MushMash_Constants.get_cell_uuid(i, j)

func _initialise_position_indexed_cells_map():
	pass

func _get_uuid(x, y):
	return map.uuid_map[y * constants.height + x]

func _input(event):
	$InputHandles.handle_inputs(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	map.mover._update_cell_world_positions()
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
	position_indexed_cells_map_initialiser = []
	var row
	for i in range(constants.height):
		row = []
		for j in range(constants.width):
			row.append(0)
		position_indexed_cells_map_initialiser.append(row)
	return position_indexed_cells_map_initialiser




func _get_all_cells():
	return map.on_map_cells
	
	
func _get_all_cells_v1():
	var all_cells = []
	
	for j in map.position_indexed_cells_map.keys():
		for i in map.position_indexed_cells_map[j].keys():
			if map.position_indexed_cells_map[j][i] != null:
				all_cells.append(map.position_indexed_cells_map[j][i])
	return all_cells



func _get_all_typed_cells(types: Array = [MushMashCell.CellTypes.Player]):
	var all_cells = []
	for j in map.position_indexed_cells_map.keys():
		for i in map.position_indexed_cells_map[j].keys():
			var cell: MushMashCell = map.position_indexed_cells_map[j][i]
			if cell != null and cell.type in types:
				all_cells.append(map.position_indexed_cells_map[j][i])
	return all_cells


func _on_animation_player_is_ready(cell):
	push_error(cell)
	print(cell)
	



func absolute_resize_tilemap(resize_width = 80, resize_height = 80):
	var tileset: TileSet = $Map/TileMapLayerMain.tile_set
	var scaler = resize_width/tileset.tile_size.x
	
	$Map.scale = Vector2(scaler, scaler)
	
func place_cells_on_tile_map():
	pass
