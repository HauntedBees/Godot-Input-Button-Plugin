tool
extends Node2D
export(Color) var pressed_tint:Color = Color(0.2, 0.2, 0.2)
export(SpriteFrames) var sheet:SpriteFrames = preload("res://addons/input_button/InputDisplaySpriteFrames.tres") setget set_sheet
export(SpriteFrames) var overlay:SpriteFrames = preload("res://addons/input_button/InputDisplayOverlayFrames.tres") setget set_overlay_sheet
export(DynamicFont) var font:DynamicFont = preload("res://addons/input_button/ButtonFont.tres") setget set_font
export(String, "xb", "ps", "ds", "joycon") var gamepad_type := "xb" setget set_gamepad_type
export(int) var key_code := 65 setget set_key_code
export(bool) var pressed := false setget set_pressed

func _ready(): refresh_display()

func set_pressed(p:bool):
	pressed = p
	$ButtonIcon.modulate = pressed_tint if p else Color.white

func set_key_code(code:int):
	key_code = code
	refresh_display()

func set_gamepad_type(type:String):
	gamepad_type = type
	refresh_display()

func set_sheet(s:SpriteFrames):
	sheet = s
	$ButtonIcon.frames = sheet
	refresh_display()
	
func set_overlay_sheet(s:SpriteFrames):
	overlay = s
	$OverlayIcon.frames = overlay
	refresh_display()

func set_font(f:DynamicFont):
	font = f
	$ButtonText.add_font_override("font", font)
	refresh_display()

func _between(x:int, a:int, b:int) -> bool: return x >= a && x <= b
func refresh_display():
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
	$ButtonText.text = t
	$ButtonText.rect_scale = Vector2(1, 1)
	$ButtonIcon.frame = 3
	$ButtonIcon.rotation = 0
	$OverlayIcon.visible = false

func set_icon_key(icon_frame:int, rotation:float):
	$ButtonText.text = ""
	$ButtonIcon.frame = 3
	$ButtonIcon.rotation = 0
	$OverlayIcon.visible = true
	$OverlayIcon.frame = icon_frame
	$OverlayIcon.rotation_degrees = rotation

func set_big_key(t:String):
	$ButtonText.text = t
	$ButtonText.rect_scale = Vector2(0.75, 0.75)
	$ButtonIcon.frame = 4
	$ButtonIcon.rotation = 0
	$OverlayIcon.visible = false

func set_gamepad(i:int):
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
		JOY_DPAD_UP: set_rotation_button(7, 0)
		JOY_DPAD_RIGHT: set_rotation_button(7, 90)
		JOY_DPAD_DOWN: set_rotation_button(7, 180)
		JOY_DPAD_LEFT: set_rotation_button(7, -90)
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
				"ps": set_game_button("R1", 1)
				"joycon": set_game_button("RL", 1)
				_: set_game_button("R", 1)
		JOY_R2: 
			match gamepad_type:
				"xb": set_game_button("RT", 1)
				"ps": set_game_button("R2", 1)
				"ds", "joycon": set_game_button("ZR", 1)
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

func set_game_button(t:String, frame := 0):
	$ButtonText.text = t
	$ButtonText.rect_scale = Vector2(1, 1)
	$ButtonIcon.frame = frame
	$ButtonIcon.rotation = 0
	$OverlayIcon.visible = false
func set_game_button_icon(icon_frame:int, rotation := 0.0):
	$ButtonText.text = ""
	$ButtonIcon.frame = 0
	$ButtonIcon.rotation = 0
	$OverlayIcon.visible = true
	$OverlayIcon.frame = icon_frame
	$OverlayIcon.rotation_degrees = rotation
func set_rotation_button(frame:int, rotation:float):
	$ButtonText.text = ""
	$ButtonIcon.frame = frame
	$ButtonIcon.rotation_degrees = rotation
	$OverlayIcon.visible = false
