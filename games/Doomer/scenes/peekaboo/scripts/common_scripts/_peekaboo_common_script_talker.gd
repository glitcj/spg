extends _Peekaboo_Script
class_name _Peekaboo_Common_Script_Talker

@export var messages : Array[String] = []

func _on_scene_start():
	pass
	
func _on_entered_range():
	portrait.animation_player.play("talking")

func _on_exited_range():
	portrait.animation_player.play("idle")

func _on_action_within_area():
	await get_mover().face(_get_direction_to_player())
	await get_peekaboo().get_lambdas().show_messages(messages)
