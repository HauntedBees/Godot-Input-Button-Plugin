tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("InputDisplay", "Node2D", preload("res://addons/input_button/InputDisplay.gd"), get_editor_interface().get_base_control().get_icon("TouchScreenButton", "EditorIcons"))
	add_custom_type("ActionDisplay", "Node2D", preload("res://addons/input_button/ActionDisplay.gd"), get_editor_interface().get_base_control().get_icon("TouchScreenButton", "EditorIcons"))
	add_custom_type("ActionButton", "Button", preload("res://addons/input_button/ActionButton.gd"), get_editor_interface().get_base_control().get_icon("TouchScreenButton", "EditorIcons"))

func _exit_tree():
	remove_custom_type("InputDisplay")
	remove_custom_type("ActionDisplay")
	remove_custom_type("ActionButton")

func handles(obj):
	return obj is preload("res://addons/input_button/InputDisplay.gd") \
		|| obj is preload("res://addons/input_button/ActionDisplay.gd") \
		|| obj is preload("res://addons/input_button/ActionButton.gd")
