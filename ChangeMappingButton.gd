extends Button

export(String) var action_to_change:String = "ui_accept"

func _on_ChangeMappingButton_pressed(): $PopupDialog.visible = true
func _on_CancelButton_pressed(): $PopupDialog.visible = false

func _input(event:InputEvent):
	if !$PopupDialog.visible: return
	if event is InputEventMouse: return
	var is_button:bool = event is InputEventJoypadButton
	var is_motion:bool = event is InputEventJoypadMotion
	if is_button && !event.pressed: return
	if is_motion && abs(event.axis_value) < InputMap.action_get_deadzone(action_to_change): return false
	var existing_mappings := InputMap.get_action_list(action_to_change)
	for mapping in existing_mappings:
		var is_mapping_button_or_joy:bool = mapping is InputEventJoypadMotion || mapping is InputEventJoypadButton
		if is_motion && is_mapping_button_or_joy:
			InputMap.action_erase_event(action_to_change, mapping)
			event.axis_value = 1 if event.axis_value > 0 else -1
			InputMap.action_add_event(action_to_change, event)
			break
		elif is_button && is_mapping_button_or_joy:
			InputMap.action_erase_event(action_to_change, mapping)
			InputMap.action_add_event(action_to_change, event)
			break
		elif !is_button && !is_motion && mapping is InputEventKey:
			InputMap.action_erase_event(action_to_change, mapping)
			InputMap.action_add_event(action_to_change, event)
			break
	$PopupDialog.visible = false
	release_focus()
	get_tree().call_group("action_display_%s" % action_to_change, "set_action", action_to_change)
