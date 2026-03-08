extends _Peekaboo_Script

var slide_duration = 1.0

func _on_automatic():
	await peekaboo.message_window.start(["Map started..", "1", "2", "3"])
