tool
class_name InputDisplay
extends Node2D
export(Color) var pressed_tint:Color = Color(0.2, 0.2, 0.2)
export(SpriteFrames) var sheet:SpriteFrames = preload("res://addons/input_button/InputDisplaySpriteFrames.tres") setget set_sheet
export(SpriteFrames) var overlay:SpriteFrames = preload("res://addons/input_button/InputDisplayOverlayFrames.tres") setget set_overlay_sheet
export(DynamicFont) var font:DynamicFont = preload("res://addons/input_button/ButtonFont.tres") setget set_font
export(String, "xb", "ps", "ds", "joycon") var gamepad_type := "xb" setget set_gamepad_type
export(int) var key_code := 65 setget set_key_code
export(bool) var pressed := false setget set_pressed
export(bool) var compress_dpad_and_analog_sticks := false setget set_compress
export(int) var axis := 0 setget set_axis # 0 = not an axis, 1 = positive, -1 = negative

var button_icon:AnimatedSprite
var button_text:Label
var overlay_icon:AnimatedSprite

func rendered() -> bool: return is_inside_tree()

func _ready():
	button_icon = AnimatedSprite.new()
	button_icon.frames = sheet
	button_icon.modulate = pressed_tint if pressed else Color.white
	add_child(button_icon)
	
	button_text = Label.new()
	button_text.align = Label.ALIGN_CENTER
	button_text.valign = Label.VALIGN_CENTER
	button_text.clip_text = true
	button_text.rect_size = Vector2(48, 16)
	button_text.rect_position = Vector2(-24, -8)
	button_text.rect_pivot_offset = Vector2(24, 8)
	button_text.add_font_override("font", font)
	add_child(button_text)
	
	overlay_icon = AnimatedSprite.new()
	overlay_icon.frames = overlay
	add_child(overlay_icon)
	
	refresh_display()

func set_pressed(p:bool):
	pressed = p
	if !rendered(): return
	button_icon.modulate = pressed_tint if pressed else Color.white

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

func set_key(t:String):
	button_text.text = t
	button_text.rect_scale = Vector2(1, 1)
	button_icon.frame = 3
	button_icon.rotation = 0
	overlay_icon.visible = false

func set_icon_key(icon_frame:int, rotation:float):
	button_text.text = ""
	button_icon.frame = 3
	button_icon.rotation = 0
	overlay_icon.visible = true
	overlay_icon.frame = icon_frame
	overlay_icon.rotation_degrees = rotation

func set_big_key(t:String):
	button_text.text = t
	button_text.rect_scale = Vector2(0.75, 0.75)
	button_icon.frame = 4
	button_icon.rotation = 0
	overlay_icon.visible = false

func set_gamepad(i:int):
	if axis == 0:
		match(i):
			JOY_XBOX_A: # JOY_DS_B, JOY_SONY_X
				match gamepad_type:
					"xb": set_game_button("A")
					"ds": set_game_button("B")
					"ps": set_game_button_icon(4)
					"joycon": set_rotation_button(5, 180)
			JOY_XBOX_B: # JOY_DS_A, JOY_SONY_CIRCLE
				match gamepad_type:
					"xb": set_game_button("B")
					"ds": set_game_button("A")
					"ps": set_game_button_icon(2)
					"joycon": set_rotation_button(5, 90)
			JOY_XBOX_X: # JOY_DS_Y, JOY_SONY_SQUARE
				match gamepad_type:
					"xb": set_game_button("X")
					"ds": set_game_button("Y")
					"ps": set_game_button_icon(1)
					"joycon": set_rotation_button(5, -90)
			JOY_XBOX_Y: # JOY_DS_X, JOY_SONY_TRIANGLE
				match gamepad_type:
					"xb": set_game_button("Y")
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

func set_game_button(t:String, frame := 0):
	button_text.text = t
	button_text.rect_scale = Vector2(1, 1)
	button_icon.frame = frame
	button_icon.rotation = 0
	overlay_icon.visible = false
func set_game_button_icon(icon_frame:int, rotation := 0.0):
	button_text.text = ""
	button_icon.frame = 0
	button_icon.rotation = 0
	overlay_icon.visible = true
	overlay_icon.frame = icon_frame
	overlay_icon.rotation_degrees = rotation
func set_rotation_button(frame:int, rotation:float):
	button_text.text = ""
	button_icon.frame = frame
	button_icon.rotation_degrees = rotation
	overlay_icon.visible = false
