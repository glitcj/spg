extends Node
class_name _PeekaBoo

@onready var logger = %"Message Box Logger" as _Doomer_Message_Box

@onready var lambdas = %Lambdas as _PeekaBoo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

@export var player_speed = 10
@onready var player =  %Player as CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await lambdas._slide_windows_in()


func get_input():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.velocity = direction * player_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	get_input()
	# player.move_and_slide()
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.move_and_collide(direction * player_speed)
