extends Node2D
class_name _Doomer_Card

@onready var animation_player := $AnimationPlayer
@onready var sprite := $CardSprite

enum CardValue {Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Prince, Queen, King}
enum CardSuite {Diamond, Club, Heart, Spade}

static var CardValueToInt := {
	CardValue.Ace: 1,
	CardValue.Two: 2,
	CardValue.Three: 3,
	CardValue.Four: 4,
	CardValue.Five: 5,
	CardValue.Six: 6,
	CardValue.Seven: 7,
	CardValue.Eight: 8,
	CardValue.Nine: 9,
	CardValue.Ten: 10,
	CardValue.Prince: 11,
	CardValue.Queen: 12,
	CardValue.King: 13,
}

static var CardSuiteToSpriteSheetName := {
	CardSuite.Diamond: "cards_diamond",
	CardSuite.Spade: "cards_spade",
	CardSuite.Club: "cards_club",
	CardSuite.Heart: "cards_heart",
} 

var value: CardValue = CardValue.Ace
var suite: CardSuite = CardSuite.Diamond

func flip_down():
	pass

func flip_up():
	pass

func show_card_face_up_sprite():
	sprite.animation = CardSuiteToSpriteSheetName[suite]
	sprite.frame = CardValueToInt[value] - 1
	

func show_card_face_down_sprite():
	sprite.animation = "cards_other"
	sprite.frame = 0


func set_absolute_size(desired_width := 50, desired_height := 50, keep_ratio := false) -> void:
	var texture: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	
	var scale_x = float(desired_width) / texture.get_width()
	var scale_y = float(desired_height) / texture.get_height()
	sprite.scale = Vector2(scale_x, scale_y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# animation_player.play("RESET")
	# set_absolute_size(50, 50, false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
