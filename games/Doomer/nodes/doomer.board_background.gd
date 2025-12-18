extends Node2D


var parallax_accelaration = 0.001
@export var parallax_speed = Vector2(5, 5)

@onready var parallax_layers = [
	$"SubViewportContainer/SubViewport/ParallaxBackground/ParallaxLayer 1", 
	$"SubViewportContainer/SubViewport/ParallaxBackground/ParallaxLayer 2", 
	$"SubViewportContainer/SubViewport/ParallaxBackground/ParallaxLayer 3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# $SubViewportContainer/SubViewport/ParallaxBackground.scroll_offset += delta * parallelx_speed * Vector2.ONE
	for layer in parallax_layers:
		layer.motion_offset += delta * parallax_speed
		parallax_speed = parallax_speed + Vector2((randi() % 2 - 1) * parallax_accelaration, 0)
		parallax_speed = parallax_speed + Vector2(0, (randi() % 2 - 1)  * parallax_accelaration)
