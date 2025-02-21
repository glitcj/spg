extends Node2D
class_name _MushMash_ActionTimerController

var indicator_colour := "red"


signal turn_timer_timeout

@onready var turn_timer = $ActionTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2DActionIndicator.modulate = Color(1,0,0)
	$ActionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Timer: %s" % $ActionTimer.time_left
	pass


func _on_timer_timeout() -> void:
	print("AAA")
	if indicator_colour == "red":
		$Sprite2DActionIndicator.modulate = Color(0,1,0)
		indicator_colour = "green"
		
		
	elif indicator_colour == "green":
		$Sprite2DActionIndicator.modulate = Color(1,0,0)
		indicator_colour = "red"
		
	
	turn_timer_timeout.emit()
