extends Node2D
class_name _Doomer_Card_Mark

enum MarkType {ATK, DEF, Attack, Defend, DoubleDown}
enum Enumation {AddMark, RemoveMark}

@onready var sprite : Node2D = $ATK
@onready var animation_player : AnimationPlayer = $ATK/AnimationPlayer

var container : CanvasItem 
var mark_type : MarkType = MarkType.ATK

@onready var sprites = get_children()

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
	sprite = get_node("%s" % [MarkType.keys()[mark_type]])
	animation_player = get_node("%s/AnimationPlayer" % [MarkType.keys()[mark_type]])
	
	for s : Node2D in sprites:
		s.visible = false
	sprite.visible = true

func play_enumation(e : Enumation, wait : bool = false):
	animation_player.play(Enumation.keys()[e])
	if wait:
		await animation_player.animation_finished


func remove():
	# await play_enumation(Enumation.RemoveMark, true)
	queue_free()
