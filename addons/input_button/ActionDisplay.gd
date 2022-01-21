tool
class_name ActionDisplay
extends InputDisplay
export(String) var action:String = "ui_accept" setget set_action
export(int) var gamepad_slot:int = 0 setget set_joypad_idx
export(bool) var pressable:bool = true
var keypad_code := 65
var gamepad_code := 0
var gamepad_connected := false

func _ready():
	Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	set_action(action)

func _input(event):
	if !pressable: return
	if event.is_action_pressed(action):
		set_pressed(true)
	elif event.is_action_released(action):
		set_pressed(false)

func set_action(a:String):
	action = a
	if !rendered(): return
	var actions = InputMap.get_action_list(action) # sometimes doesn't work in editor?
	if actions.size() == 0: return
	var has_set_key := false # we want to just use the first one
	var has_set_pad := false
	for action_event in actions:
		if action_event is InputEventKey:
			if has_set_key: continue
			else:
				has_set_key = true
				keypad_code = action_event.scancode
		elif action_event is InputEventJoypadButton:
			if has_set_pad: continue
			else:
				has_set_pad = true
				gamepad_code = action_event.button_index
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
		gamepad_connected = false
		set_key_code(keypad_code)
	else:
		gamepad_connected = true
		set_key_code(gamepad_code)
		if gamepad_name == "ps4 controller" || gamepad_name == "ps5_controller" || gamepad_name.find("dualshock") >= 0 || gamepad_name.find("sony") >= 0:
			set_gamepad_type("ps")
		elif gamepad_name.find("nintendo") >= 0 || gamepad_name.find("pro controller") >= 0:
			set_gamepad_type("ds")
		else:
			set_gamepad_type("xb")
