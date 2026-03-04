extends _Peekaboo_Script

func _on_trigger():
	while true:
		mover.move(Vector2(0, 500))
		portrait.animation_player.play("move_down")
		await mover.finished_movement
		await mover.wait(1.0)
		
		mover.move(Vector2(0, -500))
		portrait.animation_player.play("move_up")
		await mover.finished_movement
		await mover.wait(1.0)
