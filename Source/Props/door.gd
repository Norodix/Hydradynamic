extends Node3D
class_name AirlockDoor

var is_moving = false
var is_open = false
@onready var anim = $AnimationPlayer

signal open_finished
signal close_finished


func open():
	if not is_open and not is_moving:
		is_moving = true
		anim.play("Open")
		await anim.animation_finished
		is_open = true
		is_moving = false
	await get_tree().create_timer(0.3).timeout
	emit_signal("open_finished")


func close():
	if is_open and not is_moving:
		is_moving = true
		anim.play_backwards("Open")
		await anim.animation_finished
		is_open = false
		is_moving = false
	await get_tree().create_timer(0.3).timeout
	emit_signal("close_finished")
