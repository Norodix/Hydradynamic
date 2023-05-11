extends Node3D

@export var head_count = 1

signal activate

@onready var img : Sprite3D = $Sprite3D
@onready var txt : Label3D = $Label3D
func _ready():
	$Label3D.text = str(head_count) + "x"
	var aabb_img = img.get_aabb()
	var aabb_txt = txt.get_aabb()
	var lp = aabb_img.size.x * img.transform.basis.get_scale().x
	var lt = aabb_txt.size.x * txt.transform.basis.get_scale().x
	var L = lp + lt
	txt.transform.origin.x = - L/2 + lt/2
	img.transform.origin.x = - L/2 + lt + lp/2


func _on_area_3d_body_entered(body):
	if body.has_method("get_head_count"):
		var body_headcount = body.get_head_count()
		print(body_headcount, " vs ", head_count)
		if body_headcount == head_count:
			print("Scanner activate")
			emit_signal("activate")
