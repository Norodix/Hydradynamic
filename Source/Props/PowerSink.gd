extends Area3D

@onready var timeout = 0.1
var time_elapsed = 100
@onready var plug : MeshInstance3D = $Electric_Socket/Plug

signal activate
signal deactivate

func _process(delta):
	var mat : Material = plug.get_active_material(0)
	var electricity_pass = mat.next_pass.next_pass
	#print("Setting: ", power)
	electricity_pass.set_shader_parameter("Shock_Bool", is_powered())
	if is_powered():
		pass
	else:
		pass


var was_powered = false
func _physics_process(delta):
	time_elapsed += delta
	if is_powered() and not was_powered:
		print("Activate sink", self)
		emit_signal("activate")
	if was_powered and not is_powered():
		emit_signal("deactivate")
	was_powered = is_powered()


func power():
	time_elapsed = 0


func is_powered():
	return time_elapsed < timeout
