extends Node
class_name MushMashCellInitialiser

func _ready():
	# _preload_animation_sprites()
	# ready.connect(get_parent().change_sprite_sheet)
	pass

enum AvailableStates {Idle, Excited, ReadyForAction}
enum CellTypes {Player, Oponnent, Immovable}

var height: int = 100
var width: int = 100
var state: int = AvailableStates.Idle
var uuid: String

var type: int = CellTypes.Immovable

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
enum AvailableSprites {Mushroom, Flower, Wall, Mole, HatMole, HeartRed, Eye}

var sprite_sheets: Dictionary
var cell_sprite := AvailableSprites.Mushroom

	
func _preload_animation_sprites():
	sprite_sheets[AvailableSprites.Mushroom] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Octopus/SpriteSheet.png")
	sprite_sheets[AvailableSprites.HeartRed] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/HeartRed/SpriteSheet.png")
	sprite_sheets[AvailableSprites.Mole] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Mole2/Mole2.png")
	sprite_sheets[AvailableSprites.HatMole] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Characters/CamouflageGreen/SpriteSheet.png")
	sprite_sheets[AvailableSprites.Eye] = preload("res://assets/itch.io/Ninja Adventure - Asset Pack/Actor/Monsters/Eye/Eye.png")
