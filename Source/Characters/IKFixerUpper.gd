extends Node3D


@onready var ik : SkeletonIK3D = $"../Head_Armature/Skeleton3D/Neck_IK"
@onready var skeleton : Skeleton3D = $"../Head_Armature/Skeleton3D"
var bones : Array = []


func _ready():
	ik.stop()
	bones = get_bone_children_recursive(skeleton, skeleton.find_bone("Head"))


func _process(delta):
	ik.start(true)
	# IK uses bones_global_pose_override
	# Copy the override poses to the real poses
	for bone in bones:
		var pose : Transform3D = skeleton.get_bone_global_pose_override(bone)
		# Rotate x to its place 
		var X = Vector3(1, 0, 0)
		var Y = pose.basis.y.normalized()
		var Z = X.cross(Y).normalized()
		var newbasis = Basis(X, Y, Z).orthonormalized().scaled(pose.basis.get_scale())
		var newpose = Transform3D(newbasis, pose.origin)
		DDD.DrawCoords(skeleton.global_transform * newpose.scaled(Vector3(1, 1, 1)))
		skeleton.set_bone_global_pose_override(bone, newpose, 1, true)


func get_bone_children_recursive(skeleton : Skeleton3D, root_index : int):
	var bones = skeleton.get_bone_children(root_index)
	var i = 0
	while i < bones.size():
		bones += skeleton.get_bone_children(bones[i])
		i += 1
	return bones
