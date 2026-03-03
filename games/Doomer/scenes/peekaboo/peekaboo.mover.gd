extends Node
class_name _Peekaboo_Mover

signal finished_movement
enum MovementType {Linear, Random, Exponential}
enum StateMachine {Moving, Stopped}

@onready var parent = get_parent() as Node2D
@export var destination = Vector2.ZERO as Vector2

@export var type = MovementType.Linear as MovementType
@export var steps = 50
@export var max_distance_per_step = 20.0


var tolerable_divergence = 25



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	assert(get_parent() is Node2D)



func move(_destination : Vector2):
	destination = _destination

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (parent.position - destination).length() < tolerable_divergence:
		finished_movement.emit()
		return
	
	if type == MovementType.Linear:
		move_exponentially()
		
func move_linearly():
	var distance = destination - get_parent().position
	var stride = Vector2.ZERO
	
	stride.x = min(distance.abs().x, max_distance_per_step)
	stride.y = min(distance.abs().y, max_distance_per_step)
	
	stride.x = stride.x * sign(distance.x)
	stride.x = stride.y * sign(distance.y)
	
	print(destination, get_parent().position, distance, stride)
	pass
	
	get_parent().move_and_collide(stride)



func move_exponentially():
	parent.move_and_collide((destination - parent.position) / steps)
