extends Node2D

func _between(x:int, a:int, b:int) -> bool: return x >= a && x <= b
func _on_SimpleMotionChange_changed(action:String, event:InputEvent):
	if action != "ui_up": return
	if event is InputEventJoypadButton:
		var e := event as InputEventJoypadButton
		if !_between(e.button_index, 12, 15): return # I dunno what to do with that
		_force_change("ui_up", _button(JOY_DPAD_UP))
		_force_change("ui_left", _button(JOY_DPAD_LEFT))
		_force_change("ui_right", _button(JOY_DPAD_RIGHT))
		_force_change("ui_down", _button(JOY_DPAD_DOWN))
	elif event is InputEventJoypadMotion:
		var e := event as InputEventJoypadMotion
		match e.axis:
			0, 1:
				_force_change("ui_up", _axis(1, -1))
				_force_change("ui_down", _axis(1, 1))
				_force_change("ui_left", _axis(0, -1))
				_force_change("ui_right", _axis(0, 1))
			2, 3:
				_force_change("ui_up", _axis(3, -1))
				_force_change("ui_down", _axis(3, 1))
				_force_change("ui_left", _axis(2, -1))
				_force_change("ui_right", _axis(2, 1))

func _button(i:int) -> InputEventJoypadButton:
	var e := InputEventJoypadButton.new()
	e.pressed = true
	e.pressed = 1
	e.button_index = i
	return e
func _axis(i:int, v:float) -> InputEventJoypadMotion:
	var e := InputEventJoypadMotion.new()
	e.axis = i
	e.axis_value = v
	return e

func _force_change(action:String, event:InputEvent):
	var existing_mappings := InputMap.get_action_list(action)
	var is_button:bool = event is InputEventJoypadButton
	var is_motion:bool = event is InputEventJoypadMotion
	for mapping in existing_mappings:
		var is_mapping_button_or_joy:bool = mapping is InputEventJoypadMotion || mapping is InputEventJoypadButton
		if is_motion && is_mapping_button_or_joy:
			InputMap.action_erase_event(action, mapping)
			event.axis_value = 1 if event.axis_value > 0 else -1
			InputMap.action_add_event(action, event)
		elif is_button && is_mapping_button_or_joy:
			InputMap.action_erase_event(action, mapping)
			InputMap.action_add_event(action, event)
		elif !is_button && !is_motion && mapping is InputEventKey:
			InputMap.action_erase_event(action, mapping)
			InputMap.action_add_event(action, event)
	get_tree().call_group("action_display_ui_up", "set_action", "ui_up")
	get_tree().call_group("action_display_ui_down", "set_action", "ui_down")
	get_tree().call_group("action_display_ui_left", "set_action", "ui_left")
	get_tree().call_group("action_display_ui_right", "set_action", "ui_right")

func _on_CheckBox_toggled(button_pressed:bool):
	$GeneralDirection.visible = !button_pressed
	$ManualDirection.visible = button_pressed
