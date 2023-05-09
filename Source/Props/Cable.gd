extends MeshInstance3D

@export_node_path("Area3D") var connection

func _process(delta):
	var conn = get_node(connection)
	var mat = get_active_material(0)
	if not mat:
		return
	if conn.has_method("is_powered"):
		var power = conn.is_powered()
		var electricity_pass = mat.next_pass.next_pass
		electricity_pass.set_shader_parameter("Shock_Bool", power)
