extends Node
class_name _PeekaBoo

@onready var logger = %"Message Box Logger" as _Doomer_Message_Box

@onready var lambdas = %Lambdas as _PeekaBoo_Lambdas
@onready var getter = %Getter as _PeekaBoo_Getter

@export var player_speed = 10
@onready var player =  %Player as CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# await lambdas._slide_windows_in()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	# _on_input()
	pass
