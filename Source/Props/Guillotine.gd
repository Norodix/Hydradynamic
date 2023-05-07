extends Node3D

var can_cut = true
@onready var anim_player = $AnimationPlayer
@onready var shape = $Area3D/CollisionShape3D


func cut():
	if can_cut:
		can_cut = false
		shape.set_deferred("disabled", false)
		anim_player.play("Cut")
		await anim_player.animation_finished
		shape.set_deferred("disabled", true)
		await get_tree().create_timer(1).timeout
		anim_player.play_backwards("Cut")
		await anim_player.animation_finished
		can_cut = true
		
