extends Area3D


func _on_body_entered(body):
	if body is HydraHead:
		var h : HydraHead = body
		h.remove()
	if body is HydraBody:
		var b : HydraBody = body
		b.purge_heads()
