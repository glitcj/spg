extends Node
class_name _MushMash_Map

@onready var mushmash: _MushMash = get_parent()
@onready var mover: _MushMash_Map_Mover = $Mover
@onready var generator: _MushMash_Map_Generator = $Generator

@onready var main_layer: TileMapLayer = $TileMapLayerMain
@onready var tile_layers: Array = [$TileMapLayerL1, $TileMapLayerL2, $TileMapLayerL3]


var tile_highlighting_cells := []
var on_map_cells = []

var position_indexed_cells_map: Dictionary
var uuid_map := {}


enum Direction {Up, Down, Left, Right}


# Refactor: Fix these directions as opposite
static var DirectionUnitVector := {
	Direction.Up: Vector2i(0, -1),
	Direction.Down: Vector2i(0, 1),
	Direction.Left: Vector2i(-1, 0),
	Direction.Right: Vector2i(1, 0),
	
}


static var InputToDirection := {
	"ui_up": Direction.Up,
	"ui_down": Direction.Down,
	"ui_left": Direction.Left,
	"ui_right": Direction.Right,
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_highlighted_tiles(delta)
	pass

func _update_highlighted_tiles(delta):
	for s: Sprite2D in tile_highlighting_cells:
		pass

func random_opponent_action():
	return randi() % Direction.size()

func make_all_cells_immovable():
	return
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.is_movable = false

func reset_idle_animation_of_all_cells():
	for cell: MushMashCell in get_parent()._get_all_cells():
		cell.animation_player.play("RESET")
		cell.animation_player.queue("Idle")

func place_and_correct_on_map_cells():	
	var position_indexed_cells_map := {}
	
	var tilemap_layer: TileMapLayer = get_parent().tilemap
	var tilemap_hash_map_to_world: Dictionary = {}  # Dictionary to store tile mappings
	var tilemap_hash_world_to_map: Dictionary = {}  # Dictionary to store tile mappings
	
	var world_pos
	for local_pos: Vector2i in tilemap_layer.get_used_cells():
		world_pos = tilemap_layer.to_global(tilemap_layer.map_to_local(local_pos))
		tilemap_hash_map_to_world[local_pos] = world_pos  # Store mapping in dictionary
		tilemap_hash_world_to_map[world_pos] = local_pos

	for cell: MushMashCell in get_parent().on_map_cells:	
		var lowest_distance_found = 100000000
		var lowest_distance_world_position: Vector2
		var lowest_distance_tilemap_position: Vector2
		for world_position: Vector2 in tilemap_hash_world_to_map.keys():
			var tilemap_cell_world_position_x = world_position[0]
			var tilemap_cell_world_position_y = world_position[1]
			var distance = world_position.distance_to(cell.global_position)# abs(cell.position.x - tilemap_cell_world_position_x) + abs(cell.position.y - tilemap_cell_world_position_y)
			
			if distance < lowest_distance_found:
				lowest_distance_found = distance
				lowest_distance_world_position = world_position
				lowest_distance_tilemap_position = tilemap_hash_world_to_map[lowest_distance_world_position]
				var x = 0
				pass
		
		cell.global_position = lowest_distance_world_position
		cell.map_position.x = lowest_distance_tilemap_position[0]
		cell.map_position.y = lowest_distance_tilemap_position[1]

		cell.new_map_position = cell.map_position
		cell.uuid = Variables.generate_uuid()
		on_map_cells.append(cell)
		
		
		# TODO: Separate building picm (position indexed cells map)
		if cell.map_position.y not in position_indexed_cells_map.keys():
			position_indexed_cells_map[cell.map_position.y] = {}
		position_indexed_cells_map[cell.map_position.y][cell.map_position.x] = cell
		
	return position_indexed_cells_map

func get_tilemap_as_array():
	pass
	
func get_tilemap_uuid_map():
	pass
	
func get_tilemap_cell_position(x, y):
	var tilemap_layer: TileMapLayer = get_parent().tilemap
	var local_pos = Vector2i(x,y)
	var world_pos: Vector2 = tilemap_layer.to_global(tilemap_layer.map_to_local(local_pos))
	return world_pos


func update_hud_face(texture_: Texture2D):
	get_parent().hud_face.texture = texture_
	get_parent().hud_face.scale = Vector2(3,3)

func resolve_damage_and_cell_placement():
	pass

func get_on_map_cell(x, y):
	if y in mushmash.map.position_indexed_cells_map.keys():
		if x in mushmash.map.position_indexed_cells_map[y].keys():
			return mushmash.map.position_indexed_cells_map[y][x]
	return null


func change_highlighted_tiles(positions_, colour=Color.RED):
	
	# TODO: 0-0-0-
	for p : Vector2i in positions_:
		var highlighting_sprite = Sprite2D.new()
		highlighting_sprite.position = main_layer.map_to_local(p)
		highlighting_sprite.texture = CanvasTexture.new()
		# highlighting_sprite.scale = Vector2(5, 5)
		
		rescale_sprite_to_tile_scale(highlighting_sprite)
		highlighting_sprite.z_index = 100
		highlighting_sprite.modulate = colour
		tile_highlighting_cells.append(highlighting_sprite)
		add_child(highlighting_sprite)
	
	
	
func rescale_sprite_to_tile_scale(sprite_ : Sprite2D):
	var tileset: TileSet = main_layer.tile_set
	var desired_width = tileset.tile_size.x
	var desired_height = tileset.tile_size.y
	sprite_.scale = Vector2(desired_width/sprite_.texture.get_width(), desired_height/sprite_.texture.get_height())

func clear_highlighted_tiles():
	for s : Sprite2D in tile_highlighting_cells:
		s.queue_free()
	tile_highlighting_cells = []
