extends Node
class_name _Doomer_Opponent

enum Traits {
	call_pair, 
	call_three_of_a_kind, 
	call_straight, 
	call_flush
	}

var traits : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_randomise_traits()


func _randomise_traits():
	for t in Traits.keys():
		traits[t] = randi() % 10

func description():
	var text = ""
	for t in Traits.keys():
		text  += "%s: %s\n" % [t, traits[t]]
	return text
