extends ColorRect

func _physics_process(delta):
	if Input.is_action_pressed("ui_accept"):
		set_rotation(get_rotation() + 1 * delta)
	elif Input.is_action_pressed("ui_cancel"):
		set_rotation(get_rotation() - 1 * delta)
	if Input.is_action_pressed("ui_left"):
		rect_position.x -= 60 * delta
	elif Input.is_action_pressed("ui_right"):
		rect_position.x += 60 * delta
	if Input.is_action_pressed("ui_up"):
		rect_position.y -= 60 * delta
	elif Input.is_action_pressed("ui_down"):
		rect_position.y += 60 * delta
