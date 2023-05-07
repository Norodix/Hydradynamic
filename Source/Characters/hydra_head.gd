extends RigidBody3D

@export var neck_root_offset = Vector3.ZERO
@export var is_neck_visible = true

func _process(delta):
	$Neck_Target.global_position = get_parent().global_position + neck_root_offset
#	var parent = get_parent()
#	if parent:
#		var start = parent.global_position + neck_root_offset
#		var end = self.global_position
#
#		# calculate transform from start and end
#		var Y = (start - end).normalized()
#		var X = Vector3(Y[2], Y[2], -Y[0]-Y[1])
#		if X.length() < 0.01: #make sure it is not degenerative
#			X = Vector3(-Y[1]-Y[2], Y[0], Y[0])
#		$Neck_Target.global_transform.basis = Basis(X, Y, X.cross(Y)).orthonormalized()
#		pass


func self_destruct(time = 5):
	await get_tree().create_timer(time).timeout
	self.queue_free()
