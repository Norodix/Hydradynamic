extends Control

var paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
	
	visible = paused
	Engine.time_scale = 0 if paused else 1
	get_tree().paused = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED


func _on_button_pressed():
	paused = false
	pass # Replace with function body.
