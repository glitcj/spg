extends Node2D
class_name Console

@onready var text = $Console.text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	text = Variables.global.keys()
	pass
