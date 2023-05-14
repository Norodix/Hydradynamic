extends CanvasLayer


func _process(delta):
	var hc = get_parent().get_head_count()
	$HBoxContainer/Label.text = str(hc) + "x"
