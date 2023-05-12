extends StaticBody3D


@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var cutter : CollisionShape3D = $Area3D/CollisionShape3D
var broken = false


func _ready():
	if not broken:
		anim.play("Spin")
		cutter.disabled = false


func deactivate():
	cutter.disabled = true
	anim.pause()


func reset_level():
	cutter.disabled = true
	broken = false


func hit():
	broken = true
	cutter.disabled = true
	print("Hit called")
	anim.play("Break")
