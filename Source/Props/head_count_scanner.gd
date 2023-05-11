extends Node3D

@export var head_count = 1

signal activate

func _ready():
	$Label3D.text = str(head_count)

func _enter_tree():
	$Label3D.text = str(head_count)


func _on_area_3d_body_entered(body):
	if body.has_method("get_head_count"):
		var body_headcount = body.get_head_count()
		print(body_headcount, " vs ", head_count)
		if body_headcount == head_count:
			print("Scanner activate")
			emit_signal("activate")
