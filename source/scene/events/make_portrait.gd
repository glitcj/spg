extends EventBase
class_name MakePortraitEvent

var portrait_name
var portrait_pallet
var portrait_position
var portrait_settings: PortraitSettings
# func initialise(portrait_name_, portrait_pallet_: String, portrait_position_: Vector2 = Vector2(0,0)) -> MakePortraitEvent:
func initialise(portrait_settings_: PortraitSettings) -> MakePortraitEvent:
	assert(typeof(portrait_settings_.uuid) in [TYPE_NIL, TYPE_INT, TYPE_STRING])
	# portrait_name = portrait_name_
	# portrait_pallet = portrait_pallet_
	# portrait_position = portrait_position_
	
	portrait_settings = portrait_settings_
	return self
	
func run():
	assert(portrait_settings.uuid not in Variables.portraits.keys())
	var portrait: Portrait = Queue.portrait_template.instantiate()
	portrait.initialise(portrait_settings.pallet_path)
	portrait.position = portrait.position + portrait_settings.position
	
	Variables.portraits[portrait_settings.uuid] = portrait
	
	if (portrait_settings.parent):
		portrait_settings.parent.add_child(Variables.portraits[portrait_settings.uuid])
	else:
		get_parent().add_child(Variables.portraits[portrait_settings.uuid])
	_clean_up()


func _event_type():
	return "MakePortraitEvent"
