extends RigidBody3D

@export var neck_root_offset = Vector3.ZERO
@export var is_neck_visible = true

func _process(delta):
	var neck = $Neck
	var parent = get_parent()
	if neck.mesh is CylinderMesh and parent:
		neck.visible = is_neck_visible
		
		var start = parent.global_position + neck_root_offset
		var end = self.global_position
		neck.mesh.height = start.distance_to(end)
		
		# calculate transform from start and end
		var Y = (end - start).normalized()
		var X = Vector3(Y[2], Y[2], -Y[0]-Y[1])
		if X.length() < 0.01: #make sure it is not degenerative
			X = Vector3(-Y[1]-Y[2], Y[0], Y[0])
		neck.global_transform.basis = Basis(X, Y, X.cross(Y)).orthonormalized()
		neck.global_position = (start + end) / 2
		pass
