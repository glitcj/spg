extends _Peekaboo_Script


func _on_automatic():
	while true:
		portrait.animation_player.play("move_down")
		await mover.move(Vector2i(0,-2))

		await mover.wait(1.0)
		
		# mover.move(Vector2(0, -500))
		portrait.animation_player.play("move_up")
		await mover.move(Vector2i(0,2))
		# await mover.finished_movement
		await mover.wait(1.0)
		
func _on_within_range():
	parent = parent as Node
	# variables.all[_Peekaboo_Variables.l1_1_enemies_count] += 1
	get_variables().l1_1_enemies_count += 1
	parent.queue_free()
