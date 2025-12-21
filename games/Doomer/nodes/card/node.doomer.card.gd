extends Node2D
class_name _Doomer_Card

@export var doomer : _Doomer
@export var card : AnimatedSprite2D
@export var position_container : CanvasItem

# card_scale cannot be set with @onready, must be @exported so that 
# animation players can see it
@export var card_scale : Vector2 = Vector2.ONE:
	set(value):
		card_scale = value
		if is_instance_valid(card):
			card.scale = value

@onready var animation_player := $AnimationPlayers/Card
@onready var sprite := $Sprites/Card
@onready var card_container : CanvasItem = $"Containers/HBoxContainer/Middle Container/Card Container"

var player_marks_container : CanvasItem
var enemy_marks_container : CanvasItem

enum CardValue {Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Prince, Queen, King}
enum CardSuite {Diamond, Club, Heart, Spade}

enum CardState {FacingUp, FacingDown}
enum Enumation {AttackUp, AttackDown, Buzz, FlipUp, FlipDown, FlipIn, FlipOut}

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


func flip(direction_ : Variant, wait_for_flip : bool = false):
	assert(direction_ is _Doomer_Card.CardState or  direction_ == null)
	
	if direction_ == null:
		if direction_ == _Doomer_Card.CardState.FacingUp:
			direction_ = _Doomer_Card.CardState.FacingDown
		else:
			direction_ = _Doomer_Card.CardState.FacingUp
		
	if direction_ == state and wait_for_flip:
		await play_enumation(Enumation.Buzz)
	elif direction_ == state and not wait_for_flip:	
		play_enumation(Enumation.Buzz)
	elif direction_ == _Doomer_Card.CardState.FacingUp and wait_for_flip:
		await play_enumation(Enumation.FlipUp)
	elif direction_ == _Doomer_Card.CardState.FacingUp and not wait_for_flip:
		play_enumation(Enumation.FlipUp)
	elif direction_ == _Doomer_Card.CardState.FacingDown and wait_for_flip:
		await play_enumation(Enumation.FlipDown) # flip_down()
	elif direction_ == _Doomer_Card.CardState.FacingDown and not wait_for_flip:
		play_enumation(Enumation.FlipDown)

func play_enumation(enumation : _Doomer_Card.Enumation, wait : bool = true):
	animation_player.play(Enumation.keys()[enumation])
	if wait:
		await animation_player.animation_finished

func queue_enumation(enumation : _Doomer_Card.Enumation, wait : bool = true):
	animation_player.queue(Enumation.keys()[enumation])
	if wait:
		await animation_player.animation_finished
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doomer.ready.connect(_reparent_card_to_position_container)
	ready.connect(_reparent_nodes_to_containers)

func _reparent_card_to_position_container():
	reparent(position_container)	
	# Must reset position after reparenting
	position = Vector2.ZERO

func _reparent_nodes_to_containers():
	card.reparent(card_container)
	position = Vector2.ZERO
	# animation_player.root_node = animation_player.get_path_to(self)


func _on_orchestrator_ready():
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

func set_random_card_value_and_suite():
	value = CardValue.values()[randi()%CardValue.size()]
	suite = CardSuite.values()[randi()%CardSuite.size()]


# Used by animation player	
func _change_card_state(state_: CardState):
	state = state_

func show_card_face_up_sprite():
	sprite.animation = CardSuiteToSpriteSheetName[suite]
	sprite.frame = CardValueToInt[value] - 1

func show_card_face_down_sprite():
	sprite.animation = "cards_other"
	sprite.frame = 0

func _fix_call_method_tracks():
	for anim_name in animation_player.get_animation_list():
		var animation = animation_player.get_animation(anim_name)
		
		for track_idx in range(animation.get_track_count()):
			if animation.track_get_type(track_idx) == Animation.TYPE_METHOD:
				var current_path = animation.track_get_path(track_idx)
				print("Current path: ", current_path)
				
				# Get the path to _Doomer_Card
				var new_path = animation_player.get_path_to(self)
				print("New path: ", new_path)
				print("Does _Doomer_Card exist at that path? ", animation_player.get_node_or_null(new_path) != null)
				
				animation.track_set_path(track_idx, new_path)
