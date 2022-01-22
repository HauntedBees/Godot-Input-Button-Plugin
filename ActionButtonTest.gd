extends Node2D
onready var press_text := $Label2

func _on_ActionButton_button_down(): press_text.text = "ui_down pressed"
func _on_ActionButton_button_up(): press_text.text = "ui_down released"
func _on_ActionButton_pressed(): print("\"Pressed\" Event works like normal, too!")

func _on_ActionButton2_button_down(): press_text.text = "ui_accept pressed"
func _on_ActionButton2_button_up(): press_text.text = "ui_accept released"
