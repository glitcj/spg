extends Node
class_name _Knews_AutoQuizAnswers

signal autoplay_finished
@onready var timer = Timer.new()


"""
ui_up
ui_down
ui_left
ui_right
General Actions:
ui_accept (e.g., Enter/Space/Controller A)
ui_cancel (e.g., Escape/Controller B)
ui_focus_next (e.g., Tab)
ui_focus_prev (e.g., Shift+Tab)
"""
func _ready():
	print("222", "222")
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.0  # Set the wait time to 1 second
	simulate_inputs()
	

func simulate_inputs():
	# Simulate pressing the "ui_up" action
	var input_event = InputEventAction.new()
	
	while true:
		await _wait(2.0)  # Wait for 1 second
		"""
		if rand(0.5) < 0.5:
			break
		"""
		
		input_event.action = "ui_down"
		input_event.pressed = true
		print("111111", "GONNA PRESSED")
		Input.parse_input_event(input_event)
		print("111111", "PRESSED")
		await _wait(1.0)  # Wait for 1 second

		# Simulate releasing the "ui_up" action
		input_event.pressed = false
		Input.parse_input_event(input_event)
		await _wait(1.0)  # Wait for 1 second

		input_event.action = "ui_accept"
		input_event.pressed = true
		Input.parse_input_event(input_event)
		print("111111", "PRESSED")
		await _wait(1.0)  # Wait for 1 second
		
		# Simulate releasing the "ui_up" action
		input_event.pressed = false
		Input.parse_input_event(input_event)
		await _wait(1.0)  # Wait for 1 second
		
		_clean_up()


# Helper function to wait for a specific duration
func _wait(duration: float):
	timer.wait_time = duration
	timer.start()
	await timer.timeout
	
func _clean_up():
	queue_free()
