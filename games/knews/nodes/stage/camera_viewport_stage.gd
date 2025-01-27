extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO: Replace with zooms from subviewport
	scale.x += 0.1
	scale.y += 0.1

func _physics_process(delta: float) -> void:
	pass
	# scale.x += delta * 0.001
	# scale.y += delta * 0.001
