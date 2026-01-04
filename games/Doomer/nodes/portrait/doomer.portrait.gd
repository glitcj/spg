extends Node2D
class_name _Doomer_Portrait

# signal portrait_changed
@export var doomer : _Doomer
# @onready var doomer : _Doomer = get_parent().doomer

enum Portraits {Face, Coin, TurnBoard}
enum Animations {RESET, Idle, Damage, Attack, UpdateTurn}

# enum TurnBoardAnimations {RESET, Field, Flip}
var turnboard_turn_name : String = "Field"

@onready var turnboard_label : Label = $"TurnBoard/Turn Board Control/Label Node/VBoxContainer/CenterContainer/Label"
# TODO : Add face frame randomiser for Damage and Attack

@export var portrait : Portraits
# @export var portrait : Portraits:
"""
	set(value):
		return # Fix the following to run before ready
		animation_player = PortraitMap[value][0]
		sprite = PortraitMap[value][1]

		for s in all_portrait_sprites:
			s.visible = false
		sprite.visible = true
"""

var animation_player : AnimationPlayer
var sprite : Node

@export var container : CanvasItem

var AnimationMap : Dictionary = {
	Animations.RESET : &"RESET",
	Animations.Idle : &"Idle",
}

@onready var PortraitMap : Dictionary = {
	Portraits.Face : [$Head/AnimationPlayer, $Head/AnimatedSprite2D],
	Portraits.Coin : [$Coin/AnimationPlayer, $Coin/AnimatedSprite2D],
	Portraits.TurnBoard : [$TurnBoard/AnimationPlayer, $"TurnBoard/Turn Board Control"]
}


@onready var all_portrait_sprites = [$Head/AnimatedSprite2D, $Coin/AnimatedSprite2D, $"TurnBoard/Turn Board Control"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_portrait()
	queue_enumation(Animations.RESET)
	queue_enumation(Animations.Idle)
	
	if container:
		doomer.ready.connect(_reparent_to_container)
	# portrait_changed.connect(_on_portrait_changed)

func _reparent_to_container():
	reparent(container)
	position = Vector2.ZERO

func _update_position():
	var rect = container.get_global_rect()
	global_position = rect.get_center() + Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_state():
	pass

func _on_portrait_changed():
	_update_portrait()

func _update_portrait():
	animation_player = PortraitMap[portrait][0]
	sprite = PortraitMap[portrait][1]

	for s in all_portrait_sprites:
		s.visible = false
	sprite.visible = true
	
func play_enumation(enumation : Animations, wait : bool = false):
	animation_player.play(Animations.keys()[enumation])
	if wait:
		await animation_player.animation_finished
	
func queue_enumation(enumation : Animations, wait : bool = false):
	animation_player.queue(Animations.keys()[enumation])
	if wait:
		await animation_player.animation_finished
	

func _update_turnboard_label():
	turnboard_label.text = turnboard_turn_name
	
