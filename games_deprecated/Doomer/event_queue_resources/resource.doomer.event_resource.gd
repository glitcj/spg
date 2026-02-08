extends Resource
class_name _Doomer_EventResource


var type: EventBase.EventType = EventBase.EventType.Lambda
# @export var parameter_1 : Array[String]
# @export var parameter_2 : Array[Callable]

"""
@export var character_name := ""
@export var description := ""
@export var game_start_one_liners : Array[String] =  ["Yes"]
@export var game_start_event_queue :=  ["Hello", Event.message_box().initialise(["Our guest today is{newline}Alexander Bones.", "Introduce yourself !"])]
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
