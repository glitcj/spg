extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}
enum StateMachine {Moving, Stopped}

@onready var parent = get_parent() as Node2D
var destination = Vector2.ZERO as Vector2
@export var displacement = Vector2.ZERO as Vector2

@export var type = MovementType.Linear as MovementType
@export var steps = 50
@export var max_distance_per_step = 20.0

var tolerable_divergence = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is Node2D)
	destination = parent.position
	
func move(_displacement : Vector2):
	displacement = _displacement
	destination = parent.position + displacement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (parent.position - destination).length() < tolerable_divergence:
		finished_movement.emit()
		return
	
	if type == MovementType.Linear:
		_move_linearly()
	if type == MovementType.Exponential:
		_move_exponentially()

func wait(time : float = 1.0):
	await get_tree().create_timer(time).timeout

func _move_linearly():
	var distance = destination - get_parent().position
	var stride = Vector2.ZERO
	
	stride.x = min(distance.abs().x, max_distance_per_step)
	stride.y = min(distance.abs().y, max_distance_per_step)
	
	stride.x = stride.x * sign(distance.x)
	stride.y = stride.y * sign(distance.y)

	get_parent().move_and_collide(stride)

func _move_exponentially():
	parent.move_and_collide((destination - parent.position) / steps)



func move_to_tile(tile_position : Vector2):
	var peekaboo = find_parent("_PeekaBoo") as _PeekaBoo
	var local_pos = peekaboo.map.l1.map_to_local(tile_position)
	var global_pos = peekaboo.map.l1.to_global(local_pos)
	# destination = global_pos
	move(global_pos - get_parent().position)
