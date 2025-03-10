extends Node2D
class_name MushMashCell

# TODO: Change Settings to Initialiser

# @onready var settings: MushMashCell = $Settings
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var highlighter_animation_player: AnimationPlayer = $HighlighterAnimationPlayer


enum AvailableStates {Idle, Excited, ReadyForAction}
enum CellTypes {Player, Oponnent, Immovable}

var height: int = 100
var width: int = 100
var state: int = AvailableStates.Idle
var uuid: String


var x
var y
var new_x
var new_y
var new_position: Vector2

var is_enemy: bool = false
var is_player: bool = false
var is_movable: bool = false
var can_move_now: bool = false

var is_highlighted: bool = false

enum HighlightAnimatorStates {IsHighlighted, NotHighlighted, RESET}
enum BodyAnimatorStates {Idle, RESET}

enum AvailableSprites {Mushroom, Flower, Wall, Mole, HatMole, HeartRed, Eye}
var sprite_sheets: Dictionary

@export var cell_sprite := AvailableSprites.Eye
@export var type := CellTypes.Immovable

	
func _preload_animation_sprites():
	sprite_sheets[AvailableSprites.Mushroom] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Octopus/SpriteSheet.png")
	sprite_sheets[AvailableSprites.HeartRed] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/HeartRed/SpriteSheet.png")
	sprite_sheets[AvailableSprites.Mole] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Mole2/Mole2.png")
	sprite_sheets[AvailableSprites.HatMole] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Characters/CamouflageGreen/SpriteSheet.png")
	sprite_sheets[AvailableSprites.Eye] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Eye/Eye.png")
	sprite_sheets[AvailableSprites.Flower] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Eye/Eye.png")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_preload_animation_sprites()
	print(cell_sprite)
	change_sprite_sheet(cell_sprite)


func _on_ready_sprite_change():
	# change_sprite_sheet(cell_sprite)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "(%s,%s) \n %s" % [x, y, uuid.substr(0,8)]

# TODO: Add animated sprite texture resize option
func absolute_rescale(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var scale_x = float(desired_width) / $Body/Sprite2D.texture.get_width()
	var scale_y = float(desired_height) / $Body/Sprite2D.texture.get_height()
	if keep_ratio:
		pass
	$Body.scale = Vector2(scale_x, scale_y)


func absolute_rescale_framed(desired_width := 150, desired_height := 150, keep_ratio: bool = false) -> void:
	var animated_sprite_2D: AnimatedSprite2D = $Body/AnimatedSprite2D
	var texture: Texture2D = animated_sprite_2D.sprite_frames.get_frame_texture(animated_sprite_2D.animation, animated_sprite_2D.frame)
	var scale_x = float(desired_width) / texture.get_width()
	var scale_y = float(desired_height) / texture.get_height()
	if keep_ratio:
		pass
	animated_sprite_2D.scale = Vector2(scale_x, scale_y)


func change_sprite_sheet(sprite_id: int):
	# var new_texture = settings.sprite_sheets[sprite_id]
	
	print(sprite_id)
	print(sprite_sheets)
	var new_texture = sprite_sheets[sprite_id]
	print(new_texture)
	var sprite_frames: SpriteFrames = $Body/AnimatedSprite2D.sprite_frames.duplicate()
	
	# Update the texture of all frames without changing frame configuration
	for animation_name in sprite_frames.get_animation_names():
		var frame_count = sprite_frames.get_frame_count(animation_name)
		for i in range(frame_count):
			# Get the old texture for this frame
			var old_texture = sprite_frames.get_frame_texture(animation_name, i)
			# Create a new AtlasTexture using the new sprite sheet but keep the same region
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = new_texture
			atlas_texture.region = old_texture.region
			atlas_texture.region = old_texture.region
			atlas_texture.filter_clip = old_texture.filter_clip
			
			sprite_frames.set_frame(animation_name, i, atlas_texture)
			$Body/AnimatedSprite2D.sprite_frames = sprite_frames


func _update_state_animations():
	if is_highlighted and $CellSelectionAnimationPlayer.assigned_animation != "Highlighted":
		$CellSelectionAnimationPlayer.play("Highlighted")
	elif not is_highlighted and $CellSelectionAnimationPlayer.assigned_animation != "RESET":
		$CellSelectionAnimationPlayer.play("RESET")
