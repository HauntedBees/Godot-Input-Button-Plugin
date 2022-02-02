tool
class_name InputDisplay
extends Node2D

const TEXT_OFFSET := Vector2(-30, -10)

export(bool) var use_press_sprites := false
export(Color) var pressed_tint := Color(0.2, 0.2, 0.2)
export(Color) var standard_tint := Color.white
export(SpriteFrames) var sheet:SpriteFrames = preload("res://addons/input_button/InputDisplaySpriteFrames.tres") setget set_sheet
export(SpriteFrames) var overlay:SpriteFrames = preload("res://addons/input_button/InputDisplayOverlayFrames.tres") setget set_overlay_sheet
export(DynamicFont) var font:DynamicFont = preload("res://addons/input_button/ButtonFont.tres") setget set_font
export(bool) var use_font_shadow := true
export(Color) var font_shadow_color := Color(0.0, 0.0, 0.0, 0.5)
export(String, "xb", "ps", "ds", "joycon") var gamepad_type := "xb" setget set_gamepad_type
export(int) var key_code := 65 setget set_key_code
export(bool) var pressed := false setget set_pressed
export(bool) var compress_dpad_and_analog_sticks := false setget set_compress
export(int) var axis := 0 setget set_axis # 0 = not an axis, 1 = positive, -1 = negative
export(Color) var font_color:Color = Color(1, 1, 1) setget set_font_color
func set_font_color(c:Color):
	font_color = c
	if button_text != null: button_text.modulate = c
	if overlay_icon != null: overlay_icon.modulate = c
export(Vector2) var face_button_offset := Vector2(-1, -6) setget set_face_button_offset
func set_face_button_offset(d:Vector2):
	face_button_offset = d
	refresh_display()
export(Vector2) var pressed_face_button_offset := Vector2(0, 4)
export(Vector2) var left_shoulder_button_offset := Vector2(0, -4) setget set_left_shoulder_button_offset
func set_left_shoulder_button_offset(d:Vector2):
	left_shoulder_button_offset = d
	refresh_display()
export(Vector2) var pressed_left_shoulder_button_offset := Vector2(0, 2)
export(Vector2) var right_shoulder_button_offset := Vector2(0, -4) setget set_right_shoulder_button_offset
func set_right_shoulder_button_offset(d:Vector2):
	right_shoulder_button_offset = d
	refresh_display()
export(Vector2) var pressed_right_shoulder_button_offset := Vector2(0, 2)
export(Vector2) var key_offset := Vector2(0, -5) setget set_key_offset
func set_key_offset(d:Vector2):
	key_offset = d
	refresh_display()
export(Vector2) var pressed_key_offset := Vector2(0, 2)
export(Vector2) var long_key_offset := Vector2(0, -3) setget set_long_key_offset
func set_long_key_offset(d:Vector2):
	long_key_offset = d
	refresh_display()
export(Vector2) var pressed_long_key_offset := Vector2(0, 2)
export(float) var long_key_text_scale := 0.5 setget set_long_key_text_scale
func set_long_key_text_scale(f:float):
	long_key_text_scale = f
	refresh_display()
export(Vector2) var analog_stick_offset := Vector2(0, 0) setget set_analog_stick_offset
func set_analog_stick_offset(d:Vector2):
	analog_stick_offset = d
	refresh_display()
export(Vector2) var pressed_analog_stick_offset := Vector2(0, -3) setget set_pressed_analog_stick_offset
func set_pressed_analog_stick_offset(d:Vector2):
	pressed_analog_stick_offset = d
	refresh_display()
export(Vector2) var left_analog_stick_offset := Vector2(-3, -4) setget set_left_analog_stick_offset
func set_left_analog_stick_offset(d:Vector2):
	left_analog_stick_offset = d
	refresh_display()
export(Vector2) var up_analog_stick_offset := Vector2(0, -7) setget set_up_analog_stick_offset
func set_up_analog_stick_offset(d:Vector2):
	up_analog_stick_offset = d
	refresh_display()
export(Vector2) var right_analog_stick_offset := Vector2(3, -4) setget set_right_analog_stick_offset
func set_right_analog_stick_offset(d:Vector2):
	right_analog_stick_offset = d
	refresh_display()
export(Vector2) var down_analog_stick_offset := Vector2(-1, 0) setget set_down_analog_stick_offset
func set_down_analog_stick_offset(d:Vector2):
	down_analog_stick_offset = d
	refresh_display()

var button_icon:AnimatedSprite
var button_text:Label
var button_text_shadow:Label
var overlay_icon:AnimatedSprite
var current_pressed_offset := Vector2.ZERO

func rendered() -> bool: return is_inside_tree()

func _ready():
	button_icon = AnimatedSprite.new()
	button_icon.frames = sheet
	button_icon.modulate = pressed_tint if pressed else standard_tint
	add_child(button_icon)
	
	button_text_shadow = Label.new()
	button_text_shadow.modulate = font_shadow_color
	button_text_shadow.align = Label.ALIGN_CENTER
	button_text_shadow.valign = Label.VALIGN_CENTER
	button_text_shadow.clip_text = true
	button_text_shadow.rect_size = Vector2(60, 20)
	button_text_shadow.rect_position = TEXT_OFFSET + Vector2(1, 1)
	button_text_shadow.rect_pivot_offset = Vector2(30, 10)
	button_text_shadow.add_font_override("font", font)
	add_child(button_text_shadow)
	
	button_text = Label.new()
	button_text.modulate = font_color
	button_text.align = Label.ALIGN_CENTER
	button_text.valign = Label.VALIGN_CENTER
	button_text.clip_text = true
	button_text.rect_size = Vector2(60, 20)
	button_text.rect_position = TEXT_OFFSET
	button_text.rect_pivot_offset = Vector2(30, 10)
	button_text.add_font_override("font", font)
	add_child(button_text)
	
	overlay_icon = AnimatedSprite.new()
	overlay_icon.frames = overlay
	overlay_icon.modulate = font_color
	add_child(overlay_icon)
	
	refresh_display()

func set_pressed(p:bool):
	var changed := (pressed != p) 
	pressed = p
	if !rendered(): return
	if use_press_sprites:
		var cur_frame := button_icon.frame
		if pressed:
			button_icon.animation = "pressed"
			if changed:
				button_text.rect_position += current_pressed_offset
				button_text_shadow.rect_position += current_pressed_offset
				overlay_icon.position += current_pressed_offset
		else: 
			button_icon.animation = "default"
			if changed:
				button_text.rect_position -= current_pressed_offset
				button_text_shadow.rect_position -= current_pressed_offset
				overlay_icon.position -= current_pressed_offset
		button_icon.frame = cur_frame
	else:
		button_icon.modulate = pressed_tint if pressed else standard_tint

func set_key_code(code:int):
	key_code = code
	refresh_display()

func set_axis(i:int):
	axis = i
	refresh_display()
	
func set_compress(b:bool):
	compress_dpad_and_analog_sticks = b
	refresh_display()

func set_gamepad_type(type:String):
	gamepad_type = type
	refresh_display()

func set_sheet(s:SpriteFrames):
	sheet = s
	if !is_inside_tree(): return
	button_icon.frames = sheet
	refresh_display()

func set_overlay_sheet(s:SpriteFrames):
	overlay = s
	if !rendered(): return
	overlay_icon.frames = overlay
	refresh_display()

func set_font(f:DynamicFont):
	font = f
	if !rendered(): return
	button_text.add_font_override("font", font)
	refresh_display()

func _between(x:int, a:int, b:int) -> bool: return x >= a && x <= b

func refresh_display():
	if !rendered(): return
	button_icon.modulate = standard_tint
	if _between(key_code, JOY_BUTTON_0, JOY_BUTTON_22): set_gamepad(key_code)
	elif key_code == KEY_SPACE: set_big_key("Space")
	elif _between(key_code, KEY_EXCLAM, KEY_YDIAERESIS): set_key(char(key_code))
	elif _between(key_code, KEY_F1, KEY_F16): set_key("F%s" % (key_code - 16777243))
	elif key_code >= KEY_ESCAPE:
		match key_code:
			KEY_ESCAPE: set_big_key("Esc")
			KEY_TAB: set_big_key("Tab")
			KEY_BACKSPACE: set_big_key("Bckspc")
			KEY_ENTER, KEY_KP_ENTER: set_big_key("Entr")
			KEY_INSERT: set_big_key("Insert")
			KEY_DELETE: set_big_key("Del")
			KEY_PAUSE: set_big_key("Pause")
			KEY_PRINT: set_big_key("PrtScrn")
			KEY_SYSREQ: set_big_key("SysReq")
			KEY_CLEAR: set_big_key("Clr")
			KEY_HOME: set_big_key("Home")
			KEY_END: set_big_key("End")
			KEY_LEFT: set_icon_key(0, -90)
			KEY_UP: set_icon_key(0, 0)
			KEY_RIGHT: set_icon_key(0, 90)
			KEY_DOWN: set_icon_key(0, 180)
			KEY_PAGEUP: set_big_key("PgUp")
			KEY_PAGEDOWN: set_big_key("PgDn")
			KEY_SHIFT: set_big_key("Shift")
			KEY_CONTROL: set_big_key("Ctrl")
			KEY_ALT: set_big_key("Alt")
			KEY_CAPSLOCK: set_big_key("Caps")
			KEY_NUMLOCK: set_big_key("NumLck")
			KEY_SCROLLLOCK: set_big_key("ScrlLk")
			_: set_big_key("??") # don't use weird keys in your game please
	else: set_big_key("??")
func set_gamepad(i:int):
	if axis == 0:
		match(i):
			JOY_XBOX_A: # JOY_DS_B, JOY_SONY_X
				match gamepad_type:
					"xb":
						set_game_button("A")
						button_icon.modulate = Color(0, 1, 0)
					"ds": set_game_button("B")
					"ps": set_game_button_icon(4)
					"joycon": set_rotation_button(5, 180)
			JOY_XBOX_B: # JOY_DS_A, JOY_SONY_CIRCLE
				match gamepad_type:
					"xb":
						set_game_button("B")
						button_icon.modulate = Color(1, 0, 0)
					"ds": set_game_button("A")
					"ps": set_game_button_icon(2)
					"joycon": set_rotation_button(5, 90)
			JOY_XBOX_X: # JOY_DS_Y, JOY_SONY_SQUARE
				match gamepad_type:
					"xb":
						set_game_button("X")
						button_icon.modulate = Color(0, 0, 1)
					"ds": set_game_button("Y")
					"ps": set_game_button_icon(1)
					"joycon": set_rotation_button(5, -90)
			JOY_XBOX_Y: # JOY_DS_X, JOY_SONY_TRIANGLE
				match gamepad_type:
					"xb":
						set_game_button("Y")
						button_icon.modulate = Color(1, 1, 0)
					"ds": set_game_button("X")
					"ps": set_game_button_icon(3)
					"joycon": set_rotation_button(5, 0)
			JOY_DPAD_UP:
				if compress_dpad_and_analog_sticks: set_game_button("", 6)
				else: set_rotation_button(7, 0)
			JOY_DPAD_RIGHT: 
				if compress_dpad_and_analog_sticks: set_game_button("", 6)
				else: set_rotation_button(7, 90)
			JOY_DPAD_DOWN: 
				if compress_dpad_and_analog_sticks: set_game_button("", 6)
				else: set_rotation_button(7, 180)
			JOY_DPAD_LEFT: 
				if compress_dpad_and_analog_sticks: set_game_button("", 6)
				else: set_rotation_button(7, -90)
			JOY_L: 
				match gamepad_type:
					"ps": set_game_button("L1", 1)
					"joycon": set_game_button("SL", 1)
					_: set_game_button("L", 1)
			JOY_L2:
				match gamepad_type:
					"xb": set_game_button("LT", 1)
					"ps": set_game_button("L2", 1)
					"ds", "joycon": set_game_button("ZL", 1)
			JOY_L3: set_game_button("L3", 9)
			JOY_R: 
				match gamepad_type:
					"ps": set_game_button("R1", 2)
					"joycon": set_game_button("RL", 2)
					_: set_game_button("R", 2)
			JOY_R2: 
				match gamepad_type:
					"xb": set_game_button("RT", 2)
					"ps": set_game_button("R2", 2)
					"ds", "joycon": set_game_button("ZR", 2)
			JOY_R3: set_game_button("R3", 9)
			JOY_START:
				match gamepad_type:
					"ds", "joycon": set_game_button("+", 4)
					"ps": set_game_button("Option", 4)
					_: set_game_button("Start", 4)
			JOY_SELECT: 
				match gamepad_type:
					"ds", "joycon": set_game_button("-", 4)
					"ps": set_game_button("Share", 4)
					_: set_game_button("Back", 4)
	else:
		match(i):
			JOY_AXIS_0:
				if compress_dpad_and_analog_sticks: set_game_button("L", 8)
				elif axis > 0: set_game_button("L", 14)
				else: set_game_button("L", 12)
			JOY_AXIS_1:
				if compress_dpad_and_analog_sticks: set_game_button("L", 8)
				elif axis > 0: set_game_button("L", 15)
				else: set_game_button("L", 13)
			JOY_AXIS_2:
				if compress_dpad_and_analog_sticks: set_game_button("R", 8)
				elif axis > 0: set_game_button("R", 14)
				else: set_game_button("R", 12)
			JOY_AXIS_3:
				if compress_dpad_and_analog_sticks: set_game_button("R", 8)
				elif axis > 0: set_game_button("R", 15)
				else: set_game_button("R", 13)
			JOY_L2:
				match gamepad_type:
					"xb": set_game_button("LT", 1)
					"ps": set_game_button("L2", 1)
					"ds", "joycon": set_game_button("ZL", 1)
			JOY_R2: 
				match gamepad_type:
					"xb": set_game_button("RT", 2)
					"ps": set_game_button("R2", 2)
					"ds", "joycon": set_game_button("ZR", 2)

func set_key(t:String):
	set_button_text_info(t, key_offset)
	button_icon.frame = 3
	button_icon.rotation = 0
	overlay_icon.visible = false
	current_pressed_offset = pressed_key_offset
func set_icon_key(icon_frame:int, rotation:float):
	set_button_text_info("", key_offset)
	button_icon.frame = 3
	button_icon.rotation = 0
	overlay_icon.visible = true
	overlay_icon.frame = icon_frame
	overlay_icon.rotation_degrees = rotation
	current_pressed_offset = pressed_key_offset
func set_big_key(t:String):
	if button_text == null: return
	set_button_text_info(t, long_key_offset, long_key_text_scale)
	button_icon.frame = 4
	button_icon.rotation = 0
	overlay_icon.visible = false
	current_pressed_offset = pressed_long_key_offset
func set_game_button(t:String, frame := 0):
	set_button_text(t)
	set_button_text_scale(long_key_text_scale if frame == 4 else 1.0)
	button_icon.frame = frame
	button_icon.rotation = 0
	overlay_icon.visible = false
	current_pressed_offset = Vector2.ZERO
	match frame:
		0: set_button_text_pos(face_button_offset, pressed_face_button_offset)
		1: set_button_text_pos(left_shoulder_button_offset, pressed_left_shoulder_button_offset)
		2: set_button_text_pos(right_shoulder_button_offset, pressed_right_shoulder_button_offset)
		4: set_button_text_pos(long_key_offset, pressed_long_key_offset)
		8: set_button_text_pos(analog_stick_offset)
		9: set_button_text_pos(pressed_analog_stick_offset)
		12: set_button_text_pos(left_analog_stick_offset)
		13: set_button_text_pos(up_analog_stick_offset)
		14: set_button_text_pos(right_analog_stick_offset)
		15: set_button_text_pos(down_analog_stick_offset)
func set_game_button_icon(icon_frame:int, rotation := 0.0):
	set_button_text_info("")
	current_pressed_offset = pressed_face_button_offset
	button_icon.modulate = standard_tint
	button_icon.frame = 0
	button_icon.rotation = 0
	overlay_icon.position = face_button_offset
	overlay_icon.visible = true
	overlay_icon.frame = icon_frame
	overlay_icon.rotation_degrees = rotation
func set_rotation_button(frame:int, rotation:float):
	set_button_text_info("")
	button_icon.frame = frame
	button_icon.rotation_degrees = rotation
	overlay_icon.visible = false

func set_button_text_info(text:String, position := Vector2.ZERO, scale := 1.0):
	set_button_text(text)
	set_button_text_pos(position)
	set_button_text_scale(scale)
func set_button_text_pos(v:Vector2, press_offset := Vector2.ZERO):
	button_text.rect_position = TEXT_OFFSET + v
	button_text_shadow.rect_position = TEXT_OFFSET + v + Vector2(1, 1)
	current_pressed_offset = press_offset
func set_button_text_scale(s:float):
	var v := Vector2(s, s)
	button_text.rect_scale = v
	button_text_shadow.rect_scale = v
func set_button_text(t:String):
	button_text.text = t
	button_text_shadow.text = t
