extends Node2D
class_name _Doomer_Card

@onready var animation_player := $AnimationPlayer
@onready var sprite := $CardSprite

enum CardValue {Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Prince, Queen, King}
enum CardSuite {Diamond, Club, Heart, Spade}

enum CardState {FacingUp, FacingDown}

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
var state: CardState = CardState.FacingDown

func flip_down():
	state = CardState.FacingDown

func flip_up():
	state = CardState.FacingUp

func change_state(state_ : CardState):
	state = state_

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_state_machine()
	
func _update_state_machine():
	if state == CardState.FacingUp:
		_while_card_is_facing_up()
	if state == CardState.FacingDown:
		_while_card_is_facing_down()


func _while_card_is_facing_down():
	if not sprite.animation == "cards_other" or not sprite.frame == 0:
		show_card_face_down_sprite()

func _while_card_is_facing_up():
	if not sprite.animation == CardSuiteToSpriteSheetName[suite] or not sprite.frame == CardValueToInt[value] - 1:
		show_card_face_up_sprite()
