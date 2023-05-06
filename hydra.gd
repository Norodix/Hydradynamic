extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var cam = $CameraPivot/CameraRod/Camera3D

@onready var controllable_list = [self]
var control_index = 0
const head_force_multiplier = 20
const head_damping = 5

const head_max_distance = 3

@onready var headscene = preload("res://hydra_head.tscn")
@onready var neck_root = $NeckPoint


func _ready():
	Globals.player = self
	add_head()
	add_head()


func add_head():
	var hs = headscene.instantiate()
	self.add_child(hs)
	hs.global_position = neck_root.global_position + Vector3(randf_range(-1, 1), randf_range(0.2, 1), randf_range(-1, 1))
	hs.top_level = true
	controllable_list.append(hs)


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


func _process(delta):
	if Input.is_action_just_pressed("control_next"):
		control_index = (control_index + 1) % controllable_list.size()
	$Indicator.global_position = controllable_list[control_index].global_position + Vector3(0, 0.6, 0)


func _physics_process(delta):
	check_head_trigger()
	# Pull back heads when too far
	for head in controllable_list:
		var d =  neck_root.global_position - head.global_position
		if d.length() > head_max_distance:
			head.apply_central_force(d.normalized()*30)
	
	
	
	# Move
	if controllable_list[control_index] != self:
		control_head(controllable_list[control_index])
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (cam.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func control_head(head : RigidBody3D):
	var fwbw = Input.get_axis("Forward", "Backward") # negative Z
	var ltrt = Input.get_axis("Left", "Right")
	var updw = Input.get_axis("Down", "Up")
	var inputDir = Vector3(ltrt, updw, fwbw).limit_length(1.0)
	
	head.apply_central_force(cam.global_transform.basis * inputDir * head_force_multiplier)
	head.linear_damp = head_damping
	return

