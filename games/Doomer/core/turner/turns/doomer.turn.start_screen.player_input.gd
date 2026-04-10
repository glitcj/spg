extends _Core_Turn
class_name _Doomer_Turn_Start_Screen_Player_Input

var accepted_inputs = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var wait_amount : float = .2

func _init() -> void:
	super()
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2


func on_turn_start():
	pass

func _input(event: InputEvent) -> void:
	if not event is InputEventKey: return
	if not (event.pressed and not event.echo): return
	
	if (event as InputEventKey).keycode in accepted_inputs:
		await doomer.lambdas.change_scene(doomer.scene.peekaboo)
		on_turn_end()
		
