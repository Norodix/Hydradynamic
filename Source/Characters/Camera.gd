extends Camera3D

@onready var camera_pivot = $"../.."
@onready var camera_rod = $".."

@export var camera_min_vertical_rotation : float = -75.0
@export var camera_max_vertical_rotation : float = 75.0
@export var mouse_sensitivity : float = 0.15
@onready var camera_target : Node3D = $"../../.."
@onready var ss = PhysicsServer3D.space_get_direct_state(get_world_3d().space)
@onready var body : Node3D = $"../Body"
@onready var cast_query = PhysicsShapeQueryParameters3D.new()
@onready var whisker_query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
var whisker_num = 12
var cast_shape : Shape3D
var excludeRID : Array[RID]
const cam_near_clip = 0.1


func _ready():
	cast_shape = SphereShape3D.new()
	cast_shape.radius = 0.05
	cast_query.collision_mask = 1 << Globals.layers.environment 
	cast_query.margin = 0.1
	cast_query.shape_rid = cast_shape
	
	var excludenodes = get_tree().get_nodes_in_group("cam_no_clip")
	for node in excludenodes:
		excludeRID.append(node.get_rid())
		pass
	
	cast_query.exclude = excludeRID


func _process(delta):
	var from = camera_target.global_position
	var to = body.global_position
	cast_query.transform = camera_target.global_transform
	cast_query.motion = to - from
	
	var safe_portion = ss.cast_motion(cast_query)
	
	# Create whiskers
#	var whisker_has_detected = false
#	for i in whisker_num:
#		var ray = Vector3(0, 0.1, -1).rotated(Vector3(0, 0, 1), float(i) / whisker_num * 2.0 * PI)
#		ray = body.global_transform * ray
#		whisker_query.from = body.global_position
#		whisker_query.to = ray
#		var hit = ss.intersect_ray(whisker_query)
#		if not hit.is_empty():
#			DDD.DrawCube(ray, 0.01, Color.RED)
#			whisker_has_detected = true
#		whisker_query.to = whisker_query.from
#		whisker_query.from = ray
#		hit = ss.intersect_ray(whisker_query)
#		if not hit.is_empty():
#			whisker_has_detected = true
#	if whisker_has_detected:
#		#safe_portion[0] *= 0.8
#		pass
#	print(whisker_has_detected)
	# Whiskers done
	safe_portion[0] = clamp(safe_portion[0] * 0.8, 0, 1)
	var target_position : Vector3 = lerp(camera_target.global_position, body.global_position, safe_portion[0])
	global_position = lerp(self.global_position, target_position, 1-pow(1-0.1, delta/0.016))
	var lerp_d = target_position.distance_to(global_position)
	if lerp_d > cam_near_clip:
		near = lerp_d
	else:
		near = cam_near_clip


func rotate_camera(camera_direction : Vector2) -> void:
	camera_pivot.rotate_y(-camera_direction.x)
	camera_rod.rotate_x(-camera_direction.y)
	
	# Limit vertical rotation
	camera_rod.rotation_degrees.x = clamp(
		camera_rod.rotation_degrees.x,
		camera_min_vertical_rotation, camera_max_vertical_rotation
	)

func _unhandled_input(event: InputEvent) -> void:
	process_mouse_input(event)


func process_mouse_input(event : InputEvent) -> void:
	# Cursor movement
	if event is InputEventMouseMotion:
		var camera_direction = Vector2(
			deg_to_rad(event.relative.x * mouse_sensitivity),
			deg_to_rad(event.relative.y * mouse_sensitivity))
		
		rotate_camera(camera_direction)
