extends _Peekaboo_Script


func _on_automatic():
	while true:
		# mover.move(Vector2(0, 500))
		portrait.animation_player.play("move_down")
		await mover.move_to_tile(Vector2(2,2))

		# await mover.finished_movement

		await mover.wait(1.0)
		
		# mover.move(Vector2(0, -500))
		portrait.animation_player.play("move_up")
		await mover.move_to_tile(Vector2(2,-1))
		# await mover.finished_movement
		await mover.wait(1.0)
		
func _on_within_range():
	parent = parent as Node
	variables.all[_Peekaboo_Variables.Keys.l1_1_enemies_count] += 1
	parent.queue_free()
