extends _Peekaboo_Script


func _on_entered_range():
	portrait.animation_player.play("talking")


func _on_exited_range():
	portrait.animation_player.play("idle")
