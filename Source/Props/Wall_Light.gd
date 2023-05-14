extends Node3D

@export_node_path("Area3D") var connection
@export var is_powered = true


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
	
	$OmniLight3D.visible = is_powered
	$Wall_Light2.get_active_material(2).emission_enabled = is_powered
	
