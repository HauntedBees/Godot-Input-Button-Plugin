tool
class_name ActionDisplay
extends InputDisplay
export(String) var action:String = "ui_accept" setget set_action
export(int) var gamepad_slot:int = 0 setget set_joypad_idx
export(bool) var pressable:bool = true
export(bool) var prefer_axis:bool = true # if an axis AND button are mapped to the same action, prefer one for display
var keypad_code := -1
var gamepad_code := -1
var joypad_code := Vector2(-1, -1) # axis, amount
var gamepad_connected := false

func _ready():
	add_to_group("action_display")
	Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	set_action(action)

func _input(event):
	if !pressable: return
	if event.is_action_pressed(action):
		set_pressed(true)
	elif event.is_action_released(action):
		set_pressed(false)

func set_action(a:String):
	if is_in_group("action_display_%s" % action): remove_from_group("action_display_%s" % action)
	set_pressed(false)
	action = a
	add_to_group("action_display_%s" % action)
	if !rendered() || Engine.editor_hint: return
	var actions = InputMap.get_action_list(action) # doesn't work in editor?
	if actions.size() == 0: return
	keypad_code = -1
	gamepad_code = -1
	joypad_code = Vector2(-1, -1)
	for action_event in actions:
		if action_event is InputEventKey:
			if keypad_code >= 0: continue
			else: keypad_code = action_event.scancode
		elif action_event is InputEventJoypadButton:
			if gamepad_code >= 0: continue
			else: gamepad_code = action_event.button_index
		elif action_event is InputEventJoypadMotion:
			if joypad_code.x >= 0: continue
			else: joypad_code = Vector2(action_event.axis, action_event.axis_value)
	_set_joypad_type()

func _joy_connection_changed(id:int, connected:bool):
	if id != gamepad_slot: return
	gamepad_connected = connected
	_set_joypad_type()

func set_joypad_idx(i:int):
	gamepad_slot = i
	_set_joypad_type()

func _set_joypad_type():
	if !rendered(): return
	var gamepad_name := Input.get_joy_name(gamepad_slot).to_lower()
	if gamepad_name == "":
		axis = 0
		gamepad_connected = false
		set_key_code(keypad_code)
	else:
		gamepad_connected = true
		if gamepad_code >= 0:
			if joypad_code.x >= 0 && prefer_axis:
				axis = joypad_code.y
				set_key_code(joypad_code.x)
			else:
				axis = 0
				set_key_code(gamepad_code)
		else:
			axis = joypad_code.y
			set_key_code(joypad_code.x)
		if gamepad_name == "ps4 controller" || gamepad_name == "ps5_controller" || gamepad_name.find("dualshock") >= 0 || gamepad_name.find("sony") >= 0:
			set_gamepad_type("ps")
		elif gamepad_name.find("nintendo") >= 0 || gamepad_name.find("pro controller") >= 0:
			set_gamepad_type("ds")
		else:
			set_gamepad_type("xb")
