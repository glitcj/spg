extends Node2D
class_name _Doomer_Card_Mark

enum MarkType {ATK, Attack, Defend, DoubleDown}
enum Enumation {AddMark, RemoveMark}

@onready var sprite : AnimatedSprite2D = $Sprites/ATK
@onready var animation_player : AnimationPlayer = $Animators/ATK

var container : CanvasItem 
var mark_type : MarkType = MarkType.ATK

var sprite_position : Vector2:
	set(value):
		sprite.position = value
		pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_mark_type()
	play_enumation(Enumation.AddMark)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_mark_type():
	sprite = get_node("Sprites/%s" % [MarkType.keys()[mark_type]])
	animation_player = get_node("Animators/%s" % [MarkType.keys()[mark_type]])
	

func play_enumation(e : Enumation, wait : bool = false):
	animation_player.play(Enumation.keys()[e])
	if wait:
		await animation_player.animation_changed


func remove():
	await play_enumation(Enumation.RemoveMark, true)
	queue_free()
