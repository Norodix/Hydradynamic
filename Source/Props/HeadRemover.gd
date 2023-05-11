extends Area3D
class_name HeadRemover


func _on_body_entered(body):
	if body is HydraHead:
		var h : HydraHead = body
		h.remove()
	if body is HydraBody:
		var b : HydraBody = body
		b.purge_heads()


func enable():
	self.monitoring = true
	pass


func disable():
	self.monitoring = false
	pass
