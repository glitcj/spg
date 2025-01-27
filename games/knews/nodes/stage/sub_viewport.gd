extends SubViewport

var deltasum = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	deltasum += 1
	# size += Vector2i(1,0)
	if (int(deltasum) % int(100)) > 50:
		$Camera2D.zoom = Vector2(1,1)
	elif (int(deltasum) % int(100)) < 50:
		$Camera2D.zoom = Vector2(3,3)
	
	
	# custom_minimum_size.x = custom_minimum_size.x + 1
	# custom_minimum_size.y = custom_minimum_size.x + 1
