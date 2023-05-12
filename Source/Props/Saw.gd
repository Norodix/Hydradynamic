extends Node3D


@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var cutter : CollisionShape3D = $Saw_Blade/Area3D/CollisionShape3D
@onready var sound : AudioStreamPlayer3D = $AudioStreamPlayer3D
var broken = false


func activate():
	if not broken:
		anim.play("Spin")
		rampup_sound()
		cutter.disabled = false


func deactivate():
	cutter.disabled = true
	rampdown_sound()
	anim.pause()


func reset_level():
	cutter.disabled = true
	broken = false


func hit():
	broken = true
	cutter.disabled = true
	print("Hit called")
	anim.play("Break")
	rampdown_sound()


func rampup_sound():
	sound.pitch_scale = 0.3
	sound.volume_db = -60
	sound.play()
	var sound_tween = get_tree().create_tween()
	sound_tween.tween_property(sound, "pitch_scale", 1, 1)
	sound_tween.parallel().tween_property(sound, "volume_db", -20, 1)


func rampdown_sound():
	var sound_tween = get_tree().create_tween()
	sound_tween.tween_property(sound, "pitch_scale", 0.1, 1)
	sound_tween.parallel().tween_property(sound, "volume_db", -60, 1)
