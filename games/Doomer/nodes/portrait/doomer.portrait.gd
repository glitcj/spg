extends Node2D
class_name _Doomer_Portrait

signal portrait_changed

enum Portraits {Face, Coin}
enum Animations {RESET, Idle}

@export var portrait : Portraits

var animation_player : AnimationPlayer
var sprite : AnimatedSprite2D

@export var container : CanvasItem

var AnimationMap : Dictionary = {
	Animations.RESET : &"RESET",
	Animations.Idle : &"Idle",
}

@onready var PortraitMap : Dictionary = {
	Portraits.Face : [$Head/AnimationPlayer, $Head/AnimatedSprite2D],
	Portraits.Coin : [$Coin/AnimationPlayer, $Coin/AnimatedSprite2D]
}


@onready var all_portrait_sprites = [$Head/AnimatedSprite2D, $Coin/AnimatedSprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_portrait()
	queue_enumation(Animations.RESET)
	queue_enumation(Animations.Idle)
	
	# set_absolute_size(150, 150)
	
	portrait_changed.connect(_on_portrait_changed)
	container.item_rect_changed.connect(_update_position)
	
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
	
func set_absolute_size(desired_width := 50, desired_height := 50, keep_ratio := false) -> void:
	# The absolute resize is applied on the node 2d Portrait node head
	var texture : Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	var scale_x = float(desired_width) / texture.get_width()
	var scale_y = float(desired_height) / texture.get_height()
	
	if keep_ratio:
		scale = Vector2(scale_x, scale_x)
	else:
		scale = Vector2(scale_x, scale_y)

func play_enumation(enumation : Animations):
	animation_player.play(Animations.keys()[enumation])
	

func queue_enumation(enumation : Animations):
	animation_player.queue(Animations.keys()[enumation])
	
