extends RigidBody3D
class_name HydraHead

@export var neck_root_offset = Vector3.ZERO
@export var is_cut = false
@export var rest_position = Vector3.ZERO

func _process(delta):
	if not is_cut:
		$Neck_Target.global_position = get_parent().global_position + neck_root_offset
		var parent = get_parent()
		if parent:
			var start : Vector3 = parent.global_position + neck_root_offset
			var end : Vector3 = self.global_position

			# calculate transform from start and end
			var Y = (start - end).normalized()
			var X = Vector3(Y[2], Y[2], -Y[0]-Y[1])
			if X.length() < 0.01: #make sure it is not degenerative
				X = Vector3(-Y[1]-Y[2], Y[0], Y[0])
			$Neck_Target.global_transform.basis = Basis(X, Y, X.cross(Y)).orthonormalized()
	else: # is_cut
		pass
		
#		# Shorten and widen neck
#		var skeleton : Skeleton3D = $Head_Armature/Skeleton3D
#		var max_d = parent.head_max_distance
#		#var neckbone = skeleton.find_bone("Neck_07")
#		var d = start.distance_to(end) / max_d
#		var s = d * 3#sqrt(d)
#		#var neckbones = skeleton.get_bone_children(skeleton.find_bone("Head"))
#		var neckbones = get_bone_children_recursive(skeleton, skeleton.find_bone("Neck_06"))
##		print(neckbones)
##		neckbones = [0, 1, 2, 3]
##		for neckbone in neckbones:
##			skeleton.set_bone_pose_scale(neckbone, Vector3(s, s, s))
#		#$Neck_Target.scale
#		pass


func get_bone_children_recursive(skeleton : Skeleton3D, root_index : int):
	var bones = skeleton.get_bone_children(root_index)
	var i = 0
	while i < bones.size():
		bones += skeleton.get_bone_children(bones[i])
		i += 1
	return bones


func self_destruct(time = 5):
	await get_tree().create_timer(time).timeout
	self.queue_free()


func randomize_rest_position(dist = 0.5):
	self.rest_position.x = randf_range(-dist, dist)
	self.rest_position.y = randf_range(-dist, dist)
	self.rest_position.z = randf_range(-dist, dist)
