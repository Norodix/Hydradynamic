extends StaticBody3D


@onready var anim : AnimationPlayer = $AnimationPlayer_Fan
@onready var anim_grid : AnimationPlayer = $AnimationPlayer_Grid
@onready var cutter : CollisionShape3D = $Area3D/CollisionShape3D
@onready var sound : AudioStreamPlayer3D = $AudioStreamPlayer3D_running
@onready var sound_grid : AudioStreamPlayer3D = $AudioStreamPlayer3D_grid
@onready var sound_crash : AudioStreamPlayer3D = $AudioStreamPlayer3D_crash
var broken = false


func _ready():
		anim.play("Spin")
		cutter.disabled = true
		rampup_sound()


func activate():
	if not broken:
		cutter.disabled = false
		anim_grid.play("Open")
		sound_grid.play()


func deactivate():
	if not broken:
		cutter.disabled = true
		anim_grid.play_backwards("Open")
		sound_grid.play()


func reset_level():
	cutter.disabled = true
	broken = false
	_ready()


func hit():
	broken = true
	cutter.disabled = true
	print("Hit called")
	anim.play("Break")
	anim_grid.play_backwards("Open")
	sound_grid.play()
	sound_crash.play()
	sound.stop()
	


func rampup_sound():
	sound.pitch_scale = 0.3
	sound.volume_db = -60
	sound.play()
	var sound_tween = get_tree().create_tween()
	sound_tween.tween_property(sound, "pitch_scale", 1, 1)
	sound_tween.parallel().tween_property(sound, "volume_db", -20, 1)

