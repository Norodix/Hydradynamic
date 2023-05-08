extends Area3D


func _on_body_entered(body):
	if body is HydraHead:
		var b : HydraHead = body
		b.remove()
