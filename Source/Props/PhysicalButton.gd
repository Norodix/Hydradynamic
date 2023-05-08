extends StaticBody3D


signal push
signal pull

@export var shots = 0

var is_pushed = false
@onready var detectorArea = $Detector/Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var bodies : Array[Node3D] = detectorArea.get_overlapping_bodies()
	if bodies.is_empty():
		if is_pushed:
			button_release()
	else:
		if not is_pushed:
			button_push()
	is_pushed = not bodies.is_empty()


func button_push():
	$AnimationPlayer.play("push")
	if shots != 0:
		shots -= 1
		emit_signal("push")


func button_release():
	$AnimationPlayer.play_backwards("push")
	emit_signal("pull")


func _on_area_3d_body_entered(body):
	button_push()


func _on_area_3d_body_exited(body):
	button_release()
