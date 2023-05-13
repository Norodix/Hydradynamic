extends CharacterBody3D
class_name HydraBody

const SPEED = 4.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam = $CameraPivot/CameraRod/Camera3D
@onready var cam_pivot = $CameraPivot

@onready var controllable_list : Array[Node3D] = [self]
var control_index = 0
const head_force_multiplier = 20
const head_damping = 5

const head_max_distance = 3
const head_reset_distance = 5
const aa_basis = true # Axis alligned basis
const max_head_count = 16

@onready var headscene = preload("hydra_head.tscn")
@onready var neck_root = $NeckPoint

var dance_radius = 0.7
var dance_period = 2
var dance_enabled = false

func _ready():
	Globals.player = self
	add_head()


func add_head():
	if controllable_list.size() >= max_head_count:
		return
	var hs = headscene.instantiate()
	self.add_child(hs)
#	hs.global_position = neck_root.global_position + \
#						Vector3(randf_range(-1, 1), randf_range(0.2, 1), randf_range(-1, 1))
	hs.global_position = global_position + Vector3(0, 3, 0)
	hs.top_level = true
	hs.linear_damp = head_damping
	hs.neck_root_offset = neck_root.position
	hs.connect("remove_head", remove_head)
	#hs.randomize_rest_position(0.7)
	controllable_list.append(hs)
	for i in controllable_list.size():
		var head = controllable_list[i]
		if not head is HydraHead:
			continue
		var hydra_head : HydraHead = head
		# fibonacci
		var ang = 1.618 * (i-1) * 2 * PI
		var r0 = 0.6
		var r = r0 * sqrt(i-1)
		hydra_head.rest_position = Vector3(r * cos(ang), r * sin(ang), 0.0).rotated(Vector3(1,0,0), deg_to_rad(-30))


func check_head_trigger():
	# Copy controllable list to loop over only the existing heads
	var headlist = [] + controllable_list
	for head in headlist:
		if head != self:
			check_head(head)


func check_head(head : RigidBody3D):
	# intersect ray to check if cutter hits it
	# only enable cutter collision for this moment
	var ss = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(head.global_position,
													neck_root.global_position,
													1<<Globals.layers.cut,
													[self, head])
	query.collide_with_areas = true
	query.hit_from_inside = true
	var ray = ss.intersect_ray(query)
	
	if not ray.is_empty():
		if ray.collider.has_method("hit"):
			ray.collider.hit()
		remove_head(head)
		await get_tree().create_timer(1.5).timeout
		add_head()
		add_head()
	pass


func remove_head(node : RigidBody3D):
	controllable_list.erase(node)
	control_index %= controllable_list.size()
#	self.remove_child(node)
#	get_parent().add_child(node)
	node.gravity_scale = 1
	node.linear_damp = 1
	node.is_cut = true
	node.self_destruct()


func purge_heads():
	print("PURGEHEADS")
	var index : Array = range(1, controllable_list.size())
	index.reverse()
	for i in index:
		var head = controllable_list[i]
		if head is HydraHead:
			remove_head(head)


func _process(delta):
	if Input.is_action_just_pressed("control_next"):
		control_index = (control_index + 1) % controllable_list.size()
		if control_index == 0: control_index = 1
	if Input.is_action_just_pressed("control_last"):
		control_index = (control_index - 1) % controllable_list.size()
		if control_index == 0: control_index = 1
	if Input.is_action_just_pressed("control_main"):
		control_index = 0
	$Indicator.global_position = controllable_list[control_index].global_position + Vector3(0, 0.6, 0)
	#cam_pivot.global_position = self.global_position
	cam.camera_target = controllable_list[control_index]
	cam_pivot.global_position = lerp(cam_pivot.global_position, \
									controllable_list[control_index].global_position, \
									1.0 - pow(1.0 - 0.05, delta/0.016))
	
	# Place audiolistener at player character with camera's transform
	var listener = $AudioListener3D
	listener.global_transform = cam.global_transform
	listener.global_position = lerp(listener.global_position, 
									cam.camera_target.global_position + Vector3(0, 1, 0),
									0.7)


func _unhandled_key_input(event):
	if event.pressed:
		var code = event.keycode
		if code >= KEY_0 and code <= KEY_9:
			control_index = (code - KEY_0 - 1) % controllable_list.size()


func get_head_count() -> int:
	return controllable_list.size() - 1


var zero_head_time = 0
func _physics_process(delta):
	check_head_trigger()
	if get_head_count() <= 0:
		zero_head_time += delta
	else:
		zero_head_time = 0
	if zero_head_time > 8.0:
		add_head()
		zero_head_time = 0
	# Pull back heads when too far
	for head in controllable_list:
		if not head is HydraHead:
			continue
		var h : HydraHead = head
		var d =  neck_root.global_position - head.global_position
		if d.length() > head_max_distance:
			push_head(head, d.normalized() * 2)
		if d.length() > head_reset_distance:
			head.global_position = neck_root.global_position + Vector3.UP * 1.5 \
								+ global_transform.basis * head.rest_position
			#head.apply_central_force(d.normalized() * 30)
		# Add head rotation
		var start = global_position + head.neck_root_offset
		var end = head.global_position
		var Z = (end - start).normalized()
#		var Y = (Vector3.UP - (Vector3.UP.project(Z))).normalized()
		var Y = Vector3.UP
		var X = Y.cross(Z)
		head.global_transform.basis = Basis(X, Y, Z).orthonormalized()
	
	# Move
	var input_dir = Vector2.ZERO
	var direction = Vector3.ZERO
	if controllable_list[control_index] != self:
		# Currently controlling head
		direction = control_head(controllable_list[control_index])
	else:
		# Currently controlling the body
		input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
		if get_head_count() == 0:
			# Random chicken
			input_dir = Vector2(1, 0).rotated(rand_from_seed(Engine.get_physics_frames() / 30)[0] * 10000)
		direction = (get_cam_basis() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if not Input.is_action_pressed("Sneak") and direction.length() > 0.01:
			for head in controllable_list:
				if not head is HydraHead:
					continue
				# Head desired position
				var pos_wanted = neck_root.global_position + direction * 1.5 + Vector3.UP * 1.5 \
								+ global_transform.basis * head.rest_position
				var push_dir = (pos_wanted - head.global_position)
				push_head(head, push_dir * 2)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Rotate body
	var v = velocity
	v.y = 0
	if v.length() > 0.1:
		var Z = v.normalized()
		var Y = Vector3.UP
		var X = Y.cross(Z)
		var dir_basis = Basis(X, Y, Z).orthonormalized()
		var dir_transform = Transform3D(dir_basis, global_position)
		global_transform.basis = global_transform.interpolate_with(dir_transform, 0.1).basis
	
	if v.length() > 0.1:
		$AnimationTree["parameters/playback"].travel("Hydra_Move")
	else:
		$AnimationTree["parameters/playback"].travel("Hydra_Idle")
	
	# Electricity connections
	# Assume body unpowered
	var body_powered = false
	# For each head detect if connects to power source -> power head and body
	for head in controllable_list:
		if head == self:
			continue
		var h : HydraHead = head
		if h.has_power_source():
			h.power(true)
			body_powered = true
		else:
			h.power(false)
	# If body powered:
	#     For each head detect if connects to power sink -> power head and sink
	if body_powered:
		for head in controllable_list:
			if head == self:
				continue
			var h : HydraHead = head
			var conducting = h.power_sinks()
			if conducting:
				h.power()
	
	if dance_enabled:
		for head in controllable_list:
			if not head is HydraHead:
				continue
			# Head desired position
			var pos_wanted = neck_root.global_position + direction * 1.5 + Vector3.UP * 1.5 \
							+ global_transform.basis * head.rest_position
			var t = Time.get_ticks_msec() / 1000.0
			var a = t / dance_period * 2 * PI
			var offset = global_transform.basis * Vector3(cos(a), abs(sin(a)) - 0.5, 0) * dance_radius
			offset += Vector3(0, 0, 1)
			pos_wanted += offset
			var push_dir = (pos_wanted - head.global_position)
			push_head(head, push_dir * 2)


# Return input direction, where to drag body
func control_head(head : RigidBody3D):
	var fwbw = Input.get_axis("Forward", "Backward") # negative Z
	var ltrt = Input.get_axis("Left", "Right")
	var updw = Input.get_axis("Down", "Up")
	var inputDir = Vector3(ltrt, updw, fwbw).limit_length(1.0)
	
	push_head(head, get_cam_basis() * inputDir)
	# Drag body along
	var d = head.global_position - neck_root.global_position
	if d.length() > head_max_distance:
		return d.normalized() * 0.1
		# TODO avoid jittering when not applying such small multiplier
	return Vector2.ZERO


func push_head(head : RigidBody3D, force : Vector3):
	head.apply_central_force(force * head_force_multiplier)


# Get the desired basis
# if aa_basis is true then the basis will only use the cameras y rotation
func get_cam_basis() -> Basis:
	if aa_basis:
		# X vector of cam is assumed to be horizontal
		var x = cam.global_transform.basis.x.normalized()
		var y = Vector3.UP
		var cam_z = cam.global_transform.basis.z
		cam_z.y = 0
		var z = cam_z.normalized()
		return Basis(x, y, z)
	else:
		return cam.global_transform.basis
