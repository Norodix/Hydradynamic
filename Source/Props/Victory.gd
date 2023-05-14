extends Node3D


func _ready():
	$AnimationPlayer.play_backwards("Open")

func victory():
	$AnimationPlayer.play("Open")
	Globals.player.dance_enabled = true

#func _process(delta):
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
#		victory()
