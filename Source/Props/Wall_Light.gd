extends Node3D

@export_node_path("Area3D") var connection
@export var is_powered = true
@onready var light = $OmniLight3D
@onready var mat = $Wall_Light2.get_surface_override_material(2)

func turn_on():
	is_powered = true


func turn_off():
	is_powered = false


func _process(delta):
	var conn = null
	if connection:
		conn = get_node_or_null(connection)
	var mat = get_child(0).get_active_material(0)
	if not mat:
		return
	
	# Use parent by default
	# Use connected node if present
	if not conn:
		conn = get_parent()
	if not conn:
		# something gone bad
		return
		
	if conn.has_method("is_powered"):
		is_powered = conn.is_powered()
	
func _physics_process(delta):
	if (light.light_energy < 0.1):
		light.visible = is_powered
		mat.emission_enabled = is_powered
	light.light_energy = lerp(light.light_energy, float(is_powered), 0.1)
	mat.emission_energy_multiplier = lerp(mat.emission_energy_multiplier, float(is_powered) * 3.0, 0.1)
	
