extends Node3D

@export_node_path("Area3D") var connection

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
		var power = conn.is_powered()
		var electricity_pass = mat.next_pass.next_pass
		electricity_pass.set_shader_parameter("Shock_Bool", power)
