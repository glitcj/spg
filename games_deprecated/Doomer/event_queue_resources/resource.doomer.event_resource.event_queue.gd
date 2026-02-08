extends _Doomer_EventResource
class_name _Doomer_EventResource_EventQueue


@export var events : Array[_Doomer_EventResource]
# @export var events_as_base : Array[EventBase] # This is allowed if EventBase is a Resource

var type_of_resource

func _ready():
	type = EventBase.EventType.EventQueue
	
func test_1():
	pass
