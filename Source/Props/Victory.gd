extends Node3D


func _ready():
	$AnimationPlayer.play_backwards("Open")

func victory():
	$AnimationPlayer.play("Open")
	var player = Globals.player
	if player.has_method("victory"):
		Globals.player.victory()

#func _process(delta):
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
#		victory()
