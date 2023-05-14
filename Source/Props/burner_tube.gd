extends Node3D

@onready var particle = $FireParticles3D
@onready var audio = $AudioStreamPlayer3D
@onready var light = $OmniLight3D

func _process(delta):
	if particle.emitting:
		if not audio.playing:
			audio.play()
	else:
		audio.stop()


func start():
	print("Start emit")
	particle.emitting = true
	light.visible = true
	pass

func stop():
	particle.emitting = false
	light.visible = false
	pass
