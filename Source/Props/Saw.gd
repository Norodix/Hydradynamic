extends Node3D


@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var cutter : CollisionShape3D = $Saw_Blade/Area3D/CollisionShape3D
var broken = false


func activate():
	if not broken:
		anim.play("Spin")
		cutter.disabled = false


func deactivate():
	cutter.disabled = true
	anim.pause()


func reset():
	cutter.disabled = true
	broken = false


func hit():
	broken = true
	cutter.disabled = true
	print("Hit called")
	anim.play("Break")
