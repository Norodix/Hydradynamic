extends Node3D

@onready var particle = $FireParticles3D
@onready var audio = $AudioStreamPlayer3D

func _process(delta):
	if particle.emitting:
		if not audio.playing:
			audio.play()
	else:
		audio.stop()


func start():
	print("Start emit")
	$FireParticles3D.emitting = true
	pass

func stop():
	$FireParticles3D.emitting = false
	pass
