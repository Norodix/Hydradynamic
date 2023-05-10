extends RigidBody3D
class_name HydraHead

@export var neck_root_offset = Vector3.ZERO
@export var is_cut = false
@export var rest_position = Vector3.ZERO

signal remove_head

func _process(delta):
	if not is_cut:
		var neck_root_global_offset = global_transform.basis * neck_root_offset
		$Neck_Target.global_position = get_parent().global_position + neck_root_global_offset
		var parent = get_parent()
#		if parent:
#			var start : Vector3 = parent.global_position + neck_root_global_offset
#			var end : Vector3 = self.global_position
#
#			# calculate transform from start and end
#			var Y = (start - end).normalized()
#			var X = Vector3(Y[2], Y[2], -Y[0]-Y[1])
#			if X.length() < 0.01: #make sure it is not degenerative
#				X = Vector3(-Y[1]-Y[2], Y[0], Y[0])
#			$Neck_Target.global_transform.basis = Basis(X, Y, X.cross(Y)).orthonormalized()
	else: # is_cut
		$IKFixerUpper.process_mode = Node.PROCESS_MODE_DISABLED
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
	
#	var seed : int = round((Engine.get_physics_frames() / 50)) + get_instance_id()
#	var testpower = bool(rand_from_seed(seed)[0] % 2)
#	power(testpower)


func get_bone_children_recursive(skeleton : Skeleton3D, root_index : int):
	var bones = skeleton.get_bone_children(root_index)
	var i = 0
	while i < bones.size():
		bones += skeleton.get_bone_children(bones[i])
		i += 1
	return bones


func remove():
	emit_signal("remove_head", self)


func self_destruct(time = 5):
	await get_tree().create_timer(time).timeout
	self.queue_free()


func randomize_rest_position(dist = 0.5):
	self.rest_position.x = randf_range(-dist, dist)
	self.rest_position.y = randf_range(-dist, dist)
	self.rest_position.z = randf_range(-dist, dist)


func has_power_source() -> bool:
	return $SourceDetector.has_overlapping_areas()


func power(power : bool = true):
	var mat : Material = $Head_Armature/Skeleton3D/Head.get_surface_override_material(0)
	var electricity_pass = mat.next_pass.next_pass
	#print("Setting: ", power)
	electricity_pass.set_shader_parameter("Shock_Bool", power)
	#print("Getting: ", electricity_pass.get_shader_parameter("Shock_Bool"))


func power_sinks() -> bool:
	var sinks : Array[Area3D] = $SinkDetector.get_overlapping_areas()
	if sinks.is_empty():
		return false
	
	for sink in sinks:
		sink.power()
	return true


func _exit_tree(): # When someone calls queue_free() here
	# Material error workaround....
	# Related to https://github.com/godotengine/godot/issues/67144
	$Head_Armature/Skeleton3D/Head.set("surface_material_override/0", null)
	$Head_Armature/Skeleton3D/Eyes.set("surface_material_override/0", null)
