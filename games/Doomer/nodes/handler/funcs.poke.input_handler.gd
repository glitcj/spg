extends Node
class_name _Doomer_Handler

signal finished_input_mode
enum InputMode {Inactive, Active}

var mode: InputMode = InputMode.Inactive
var input_tray : Key

@onready var doomer: _Doomer = get_parent()

# TODO: Will be extended:
# Gamepad buttons
# var button: JoyButton = JOY_BUTTON_A
# Mouse buttons
# var mouse: MouseButton = MOUSE_BUTTON_LEFT

func handle_inputs(event):
	if mode == InputMode.Inactive:
		return
	elif mode == InputMode.Active:
		_process_input(event)


func _process_input(event):
	var event_keycode = CommonFunctions.get_first_input_event_keycode(event)
	
	if event_keycode not in _Doomer_Turn_Player.accepted_inputs:
		return
		
	input_tray = event_keycode
	finished_input_mode.emit()


func _reset():
	mode = InputMode.Inactive




"""

Key Enum (Keyboard Keys)
Arrow Keys & Navigation
gdscriptKEY_LEFT
KEY_UP
KEY_RIGHT
KEY_DOWN
KEY_PAGEUP
KEY_PAGEDOWN
KEY_HOME
KEY_END
Letters (A-Z)
gdscriptKEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J,
KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T,
KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z
Numbers
gdscriptKEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9
Function Keys
gdscriptKEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7, KEY_F8,
KEY_F9, KEY_F10, KEY_F11, KEY_F12
Modifiers
gdscriptKEY_SHIFT
KEY_CTRL
KEY_ALT
KEY_META  # Windows key / Command key
KEY_CAPSLOCK
Special Keys
gdscriptKEY_ENTER
KEY_ESCAPE
KEY_BACKSPACE
KEY_TAB
KEY_SPACE
KEY_DELETE
KEY_INSERT
Numpad
gdscriptKEY_KP_0, KEY_KP_1, KEY_KP_2, KEY_KP_3, KEY_KP_4,
KEY_KP_5, KEY_KP_6, KEY_KP_7, KEY_KP_8, KEY_KP_9
KEY_KP_MULTIPLY  # *
KEY_KP_DIVIDE    # /
KEY_KP_SUBTRACT  # -
KEY_KP_PERIOD    # .
KEY_KP_ADD       # +
KEY_KP_ENTER
Punctuation & Symbols
gdscriptKEY_MINUS         # -
KEY_EQUAL         # =
KEY_BRACKETLEFT   # [
KEY_BRACKETRIGHT  # ]
KEY_BACKSLASH     # \
KEY_SEMICOLON     # ;
KEY_APOSTROPHE    # '
KEY_COMMA         # ,
KEY_PERIOD        # .
KEY_SLASH         # /
KEY_QUOTELEFT     # `

MouseButton Enum
gdscriptMOUSE_BUTTON_NONE
MOUSE_BUTTON_LEFT      # Left click
MOUSE_BUTTON_RIGHT     # Right click
MOUSE_BUTTON_MIDDLE    # Middle click / scroll wheel click
MOUSE_BUTTON_WHEEL_UP
MOUSE_BUTTON_WHEEL_DOWN
MOUSE_BUTTON_WHEEL_LEFT
MOUSE_BUTTON_WHEEL_RIGHT
MOUSE_BUTTON_XBUTTON1  # Extra button 1 (back)
MOUSE_BUTTON_XBUTTON2  # Extra button 2 (forward)

JoyButton Enum (Gamepad Buttons)
Standard Buttons
gdscriptJOY_BUTTON_A              # Xbox A / PlayStation Cross
JOY_BUTTON_B              # Xbox B / PlayStation Circle
JOY_BUTTON_X              # Xbox X / PlayStation Square
JOY_BUTTON_Y              # Xbox Y / PlayStation Triangle
JOY_BUTTON_BACK           # Select / Share
JOY_BUTTON_START          # Start / Options
JOY_BUTTON_GUIDE          # Xbox button / PS button
JOY_BUTTON_LEFT_STICK     # L3
JOY_BUTTON_RIGHT_STICK    # R3
JOY_BUTTON_LEFT_SHOULDER  # LB / L1
JOY_BUTTON_RIGHT_SHOULDER # RB / R1
D-Pad
gdscriptJOY_BUTTON_DPAD_UP
JOY_BUTTON_DPAD_DOWN
JOY_BUTTON_DPAD_LEFT
JOY_BUTTON_DPAD_RIGHT
Miscellaneous
gdscriptJOY_BUTTON_MISC1          # Xbox Series Share / PS5 Mic / Nintendo Capture
JOY_BUTTON_PADDLE1        # Xbox Elite paddle P1
JOY_BUTTON_PADDLE2        # Xbox Elite paddle P2
JOY_BUTTON_PADDLE3        # Xbox Elite paddle P3
JOY_BUTTON_PADDLE4        # Xbox Elite paddle P4
JOY_BUTTON_TOUCHPAD       # PS4/PS5 touchpad button

JoyAxis Enum (Gamepad Analog Sticks & Triggers)
gdscriptJOY_AXIS_LEFT_X           # Left stick horizontal
JOY_AXIS_LEFT_Y           # Left stick vertical
JOY_AXIS_RIGHT_X          # Right stick horizontal
JOY_AXIS_RIGHT_Y          # Right stick vertical
JOY_AXIS_TRIGGER_LEFT     # LT / L2
JOY_AXIS_TRIGGER_RIGHT    # RT / R2

Example Usage
gdscript# Keyboard
var InputToAction := {
    KEY_W: Action.MoveForward,
    KEY_S: Action.MoveBack,
    KEY_A: Action.MoveLeft,
    KEY_D: Action.MoveRight,
    KEY_SPACE: Action.Jump,
    KEY_SHIFT: Action.Sprint
}

# Gamepad
var GamepadToAction := {
    JOY_BUTTON_A: Action.Jump,
    JOY_BUTTON_B: Action.Dodge,
    JOY_BUTTON_X: Action.Attack,
    JOY_BUTTON_DPAD_UP: Action.MenuUp
}

# Mouse
var MouseToAction := {
    MOUSE_BUTTON_LEFT: Action.Shoot,
    MOUSE_BUTTON_RIGHT: Action.Aim
}

func _process_input(event):
    if event is InputEventKey and event.pressed:
        if event.keycode in InputToAction:
            perform_action(InputToAction[event.keycode])
    
    elif event is InputEventJoypadButton and event.pressed:
        if event.button_index in GamepadToAction:
            perform_action(GamepadToAction[event.button_index])
    
    elif event is InputEventMouseButton and event.pressed:
        if event.button_index in MouseToAction:
            perform_action(MouseToAction[event.button_index])
These are type-safe and give you autocomplete, unlike string-based input actions!how about joy stick co ordinates ?7:19 PMSynthesized joystick axis mechanics and practical implementation patterns.The user is asking about joystick coordinates, which are analog values from the joystick axes. In GDScript, these are accessed through JoyAxis enum and return float values between -1.0 and 1.0.
Let me provide information about:

How to access joystick axis values
The JoyAxis enum values
How to use them in a dictionary-based system
Dead zones and normalization
Examples of common patterns
Joystick coordinates come from analog axes and return float values between -1.0 and 1.0, not discrete button presses. Here's how to work with them:
JoyAxis Enum (Analog Stick Axes)
gdscriptJOY_AXIS_LEFT_X           # Left stick horizontal (-1.0 = left, 1.0 = right)
JOY_AXIS_LEFT_Y           # Left stick vertical (-1.0 = up, 1.0 = down)
JOY_AXIS_RIGHT_X          # Right stick horizontal
JOY_AXIS_RIGHT_Y          # Right stick vertical
JOY_AXIS_TRIGGER_LEFT     # Left trigger (0.0 to 1.0)
JOY_AXIS_TRIGGER_RIGHT    # Right trigger (0.0 to 1.0)
Reading Joystick Values
Method 1: Direct Input Reading
gdscriptfunc _process(delta):
    # Get current axis values
    var left_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
    var left_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
    var right_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
    var right_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
    
    # Get as Vector2
    var left_stick = Vector2(left_x, left_y)
    var right_stick = Vector2(right_x, right_y)
    
    # Move character
    velocity = left_stick * speed
    
    # Camera rotation
    camera_rotation += right_stick * sensitivity * delta
Method 2: Using InputEventJoypadMotion
gdscriptfunc _input(event):
    if event is InputEventJoypadMotion:
        match event.axis:
            JOY_AXIS_LEFT_X:
                move_direction.x = event.axis_value
            JOY_AXIS_LEFT_Y:
                move_direction.y = event.axis_value
            JOY_AXIS_RIGHT_X:
                look_direction.x = event.axis_value
            JOY_AXIS_RIGHT_Y:
                look_direction.y = event.axis_value
Dictionary-Based Approach
gdscriptenum StickAction {MoveHorizontal, MoveVertical, LookHorizontal, LookVertical}

var AxisToAction := {
    JOY_AXIS_LEFT_X: StickAction.MoveHorizontal,
    JOY_AXIS_LEFT_Y: StickAction.MoveVertical,
    JOY_AXIS_RIGHT_X: StickAction.LookHorizontal,
    JOY_AXIS_RIGHT_Y: StickAction.LookVertical
}

# Store current axis values
var axis_values := {
    StickAction.MoveHorizontal: 0.0,
    StickAction.MoveVertical: 0.0,
    StickAction.LookHorizontal: 0.0,
    StickAction.LookVertical: 0.0
}

func _input(event):
    if event is InputEventJoypadMotion:
        if event.axis in AxisToAction:
            var action = AxisToAction[event.axis]
            axis_values[action] = event.axis_value

func _process(delta):
    var move_vec = Vector2(
        axis_values[StickAction.MoveHorizontal],
        axis_values[StickAction.MoveVertical]
    )
    
    var look_vec = Vector2(
        axis_values[StickAction.LookHorizontal],
        axis_values[StickAction.LookVertical]
    )
Handling Dead Zones
gdscriptconst DEADZONE = 0.2

func apply_deadzone(value: float) -> float:
    if abs(value) < DEADZONE:
        return 0.0
    # Remap from [DEADZONE, 1.0] to [0.0, 1.0]
    return (abs(value) - DEADZONE) / (1.0 - DEADZONE) * sign(value)

func get_stick_vector(stick_x: JoyAxis, stick_y: JoyAxis) -> Vector2:
    var x = Input.get_joy_axis(0, stick_x)
    var y = Input.get_joy_axis(0, stick_y)
    
    var vec = Vector2(x, y)
    
    # Circular deadzone
    if vec.length() < DEADZONE:
        return Vector2.ZERO
    
    # Normalize and remap
    var direction = vec.normalized()
    var magnitude = (vec.length() - DEADZONE) / (1.0 - DEADZONE)
    magnitude = clamp(magnitude, 0.0, 1.0)
    
    return direction * magnitude
Complete Example
gdscriptextends CharacterBody2D

const SPEED = 200.0
const DEADZONE = 0.15

var move_input := Vector2.ZERO
var aim_input := Vector2.ZERO

func _input(event):
    if event is InputEventJoypadMotion:
        match event.axis:
            JOY_AXIS_LEFT_X:
                move_input.x = apply_deadzone(event.axis_value)
            JOY_AXIS_LEFT_Y:
                move_input.y = apply_deadzone(event.axis_value)
            JOY_AXIS_RIGHT_X:
                aim_input.x = apply_deadzone(event.axis_value)
            JOY_AXIS_RIGHT_Y:
                aim_input.y = apply_deadzone(event.axis_value)

func _physics_process(delta):
    # Movement
    velocity = move_input * SPEED
    move_and_slide()
    
    # Aiming
    if aim_input.length() > 0:
        rotation = aim_input.angle()

func apply_deadzone(value: float) -> float:
    return 0.0 if abs(value) < DEADZONE else value
Getting Both Sticks as Vectors
gdscriptfunc get_left_stick() -> Vector2:
    return Vector2(
        Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
        Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
    )

func get_right_stick() -> Vector2:
    return Vector2(
        Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
        Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
    )

func _process(delta):
    var move = get_left_stick()
    var look = get_right_stick()
    
    # Apply circular deadzone
    if move.length() > DEADZONE:
        velocity = move.normalized() * SPEED
The key difference from buttons is that axes give continuous values rather than discrete on/off states, so you typically poll them in _process() or _physics_process() rather than just in _input().


"""
