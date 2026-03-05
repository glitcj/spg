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
