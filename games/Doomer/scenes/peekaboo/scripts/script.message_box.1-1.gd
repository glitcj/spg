extends _Peekaboo_Script

var slide_duration = 1.0

func _on_automatic():
	parent = parent as _Doomer_Message_Box
	# parent.show_dialogue("Hello this is a test. Hello this is a test. Hello this is a test. Hello this is a test. ")
	parent.start(["Hello this is a test. Hello this is a test. Hello this is a test. Hello this is a test. ",
	"Hello this is a test. Hello this is a test. Hello this is a test. Hello this is a test. ",
	"Hello this is a test. Hello this is a test. Hello this is a test. Hello this is a test. ",
	])
