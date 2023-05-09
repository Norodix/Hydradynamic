extends Area3D

var timeout = 0.5
var time_elapsed = 0
@onready var plug : MeshInstance3D = $Electric_Socket/Plug

func _process(delta):
	var mat : Material = plug.get_active_material(0)
	var electricity_pass = mat.next_pass.next_pass
	#print("Setting: ", power)
	electricity_pass.set_shader_parameter("Shock_Bool", is_powered())
	if is_powered():
		pass
	else:
		pass


func _physics_process(delta):
	time_elapsed += delta


func power():
	time_elapsed = 0


func is_powered():
	return time_elapsed < timeout
