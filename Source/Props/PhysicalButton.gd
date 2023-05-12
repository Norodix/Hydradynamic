extends StaticBody3D
class_name PhysicalButton

signal push
signal pull

@export var shots = -1

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
	else: # has bodies
		if not is_pushed:
			button_push()
	is_pushed = not bodies.is_empty()


func is_powered() -> bool:
	return is_pushed


func button_push():
	$Click.play()
	$AnimationPlayer.play("push")
	if shots != 0:
		shots -= 1
		emit_signal("push")


func button_release():
	$Clack.play()
	$AnimationPlayer.play_backwards("push")
	
	emit_signal("pull")
