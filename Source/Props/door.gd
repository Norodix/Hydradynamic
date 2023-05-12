extends Node3D
class_name AirlockDoor

var is_moving = false
var is_open = false
var is_closed = true
@onready var anim = $AnimationPlayer
@onready var sound = $SoundAnimationPlayer

signal open_finished
signal close_finished


func open():
	if is_moving:
		return
	is_moving = true
	if not is_open:
		is_closed = false
		#is_moving = true
		anim.play("Open")
		sound.play("Open")
		await anim.animation_finished
		is_open = true
	await get_tree().create_timer(0.3).timeout
	emit_signal("open_finished")
	is_moving = false


func close():
	if is_moving:
		return
	is_moving = true
	if not is_closed:
		is_open = false
		#is_moving = true
		anim.play_backwards("Open")
		sound.play("Close")
		await anim.animation_finished
		is_closed = true
	await get_tree().create_timer(0.3).timeout
	emit_signal("close_finished")
	is_moving = false
