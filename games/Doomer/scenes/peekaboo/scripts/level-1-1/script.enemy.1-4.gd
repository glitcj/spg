extends _Peekaboo_Script


func _on_automatic():
	while true:
		portrait.animation_player.play("move_left")
		await mover.move(Vector2i(-3,0))
		await mover.wait(1.0)
		
		portrait.animation_player.play("move_right")
		await mover.move(Vector2i(3,0))
		await mover.wait(1.0)
		
		
func _on_action_within_range_trigger():
	parent = parent as Node
	variables.all[_Peekaboo_Variables.Keys.l1_1_enemies_count] += 1
	parent.queue_free()
