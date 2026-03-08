extends _Peekaboo_Script


func _on_automatic():
	while true:
		mover.move(Vector2(0, 500))
		portrait.animation_player.play("move_down")
		await mover.finished_movement
		await mover.wait(1.0)
		
		mover.move(Vector2(0, -500))
		portrait.animation_player.play("move_up")
		await mover.finished_movement
		await mover.wait(1.0)


func _on_within_range():
	parent = parent as Node
	parent.queue_free()
