extends _Doomer_Turn
class_name _Doomer_Turn_Change_Scene


var target_scene : _Doomer.DoomerScene
var wait_amount : float = .2

func _init(target_scene_ : _Doomer.DoomerScene) -> void:
	turn_name = "SCN"
	turn_colour = Color(0.5,.3,.5)
	name = "_Doomer_Turn_Change_Scene"
	turn_wait_time = .2

	target_scene = target_scene_
	
func on_turn_start():
	await get_tree().create_timer(doomer.turner.turner_timer.time_left/2).timeout
	doomer.turner.turner_timer.paused = true
	
	doomer.change_scene(target_scene)

	doomer.turner.turner_timer.paused = false
	return

func on_turn_end():
	pass
