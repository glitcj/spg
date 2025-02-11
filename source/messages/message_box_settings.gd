extends Object
class_name MessageBoxSettings

# class MessageBoxSettings:
var is_detached: bool = false
var is_autoplay: bool = true
var is_borderless: bool = false
	
var autoplay_wait_seconds: int = 0.2
var position: Vector2 = Vector2(0,50)

# To avoid lambdising many queues, include a parent uuid option
var parent: Node = null
var parent_uuid: String = ""
var parent_path: String = ""

# TODO
# var uuid: String = Variables.generate_uuid()
