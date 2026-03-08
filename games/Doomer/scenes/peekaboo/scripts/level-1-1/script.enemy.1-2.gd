extends _Peekaboo_Script


func _on_automatic():
	while true:
		mover.move(Vector2(-100, 0))
		portrait.animation_player.play("move_left")
		await mover.finished_movement
		await mover.wait(1.0)
		
		mover.move(Vector2(100, 0))
		portrait.animation_player.play("move_right")
		await mover.finished_movement
		await mover.wait(1.0)
		
func _on_within_range():
	parent = parent as Node
	variables.all[_Peekaboo_Variables.Keys.l1_1_enemies_count] += 1
	parent.queue_free()
