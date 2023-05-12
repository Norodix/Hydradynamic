extends Node3D


func start():
	print("Start emit")
	$FireParticles3D.emitting = true
	pass

func stop():
	$FireParticles3D.emitting = false
	pass
