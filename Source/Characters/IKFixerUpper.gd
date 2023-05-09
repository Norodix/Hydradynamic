extends Node3D


@onready var ik : SkeletonIK3D = $"../Head_Armature/Skeleton3D/Neck_IK"
@onready var skeleton : Skeleton3D = $"../Head_Armature/Skeleton3D"
var bones : Array = []


func _ready():
	ik.stop()
	bones = get_bone_children_recursive(skeleton, skeleton.find_bone("Head"))


func _process(delta):
	# Relax bones
	for i in range(0, bones.size()-1):
		var p0 :Transform3D = skeleton.get_bone_global_pose_override(bones[i-1])
		var p1 :Transform3D = skeleton.get_bone_global_pose_override(bones[i])
		var p2 :Transform3D = skeleton.get_bone_global_pose_override(bones[i+1])
		var newtransform = p0.interpolate_with(p2, 0.5)
		var relaxed_transform = p1.interpolate_with(newtransform, 0.1)
		relaxed_transform.origin = p1.origin
		relaxed_transform.origin -= (relaxed_transform.origin - p2.origin).normalized() * 0.1
		relaxed_transform.origin -= (relaxed_transform.origin - p1.origin).normalized() * 0.1
		skeleton.set_bone_global_pose_override(bones[i], relaxed_transform, 1, true)
		#DDD.DrawCoords(skeleton.global_transform * relaxed_transform.scaled(Vector3(1, 1, 1)))
		pass
	
	ik.start(true)
	# Snap the coordinates to avoid twisting issue
	for bone in bones:
		var pose : Transform3D = skeleton.get_bone_global_pose_override(bone)
		# Rotate x to its place 
		var X = Vector3(1, 0, 0)
		var Y = pose.basis.y.normalized()
		var Z = X.cross(Y).normalized()
		var newbasis = Basis(X, Y, Z).orthonormalized().scaled(pose.basis.get_scale())
		var newpose = Transform3D(newbasis, pose.origin)
		#DDD.DrawCoords(skeleton.global_transform * newpose.scaled(Vector3(1, 1, 1)))
		skeleton.set_bone_global_pose_override(bone, newpose, 1, true)


func get_bone_children_recursive(skeleton : Skeleton3D, root_index : int):
	var bones = skeleton.get_bone_children(root_index)
	var i = 0
	while i < bones.size():
		bones += skeleton.get_bone_children(bones[i])
		i += 1
	return bones
