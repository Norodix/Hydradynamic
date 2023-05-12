extends StaticBody3D


@onready var anim : AnimationPlayer = $AnimationPlayer_Fan
@onready var anim2 : AnimationPlayer = $AnimationPlayer_Grid
@onready var cutter : CollisionShape3D = $Area3D/CollisionShape3D
var broken = false


func _ready():
		anim.play("Spin")
		cutter.disabled = true


func activate():
	if not broken:
		cutter.disabled = false
		anim2.play("Open")

func deactivate():
	if not broken:
		cutter.disabled = true
		anim2.play_backwards("Open")


func reset_level():
	cutter.disabled = true
	broken = false


func hit():
	broken = true
	cutter.disabled = true
	print("Hit called")
	anim.play("Break")
	anim2.play_backwards("Open")
