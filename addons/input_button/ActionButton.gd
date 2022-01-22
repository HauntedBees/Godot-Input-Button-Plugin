class_name ActionButton
extends Button

export(PackedScene) var custom_action_display:PackedScene
export(String) var action:String = "ui_accept" setget set_action
export(Vector2) var icon_size:Vector2 = Vector2(64, 64) setget set_icon_size

var viewport:Viewport
var action_display:ActionDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = Viewport.new()
	viewport.size = icon_size
	viewport.transparent_bg = true
	viewport.disable_3d = true
	viewport.usage = Viewport.USAGE_2D
	viewport.render_target_v_flip = true
	add_child(viewport)
	if custom_action_display == null: action_display = ActionDisplay.new()
	else: action_display = custom_action_display.instance()
	action_display.action = action
	action_display.position = icon_size / 2.0
	viewport.add_child(action_display)
	icon = viewport.get_texture()
	expand_icon = true

func set_icon_size(v:Vector2):
	icon_size = v
	if viewport == null: return
	viewport.size = v
	action_display.position = v / 2.0

func set_action(a:String):
	action = a
	if action_display != null: action_display.action = a

func _input(event:InputEvent):
	if disabled: return
	if event.is_action_pressed(action): fake_press()
	elif event.is_action_released(action): fake_release()
	viewport.input(event)

func fake_press():
	var v := InputEventMouseButton.new()
	v.set_button_index(BUTTON_LEFT)
	v.set_pressed(true)
	v.set_position(rect_position)
	Input.parse_input_event(v)

func fake_release():
	var v := InputEventMouseButton.new()
	v.set_button_index(BUTTON_LEFT)
	v.set_pressed(false)
	v.set_position(rect_position)
	Input.parse_input_event(v)
	release_focus()
