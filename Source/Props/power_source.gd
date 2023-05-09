extends Area3D

@onready var shape = $CollisionShape3D
@onready var plug : MeshInstance3D = $Electric_Socket/Plug
@export var default_state = true


func _ready():
	if default_state:
		enable()
	else:
		disable()


func _process(delta):
	var mat : Material = plug.get_active_material(0)
	var electricity_pass = mat.next_pass.next_pass
	#print("Setting: ", power)
	electricity_pass.set_shader_parameter("Shock_Bool", is_powered())


func enable():
	shape.disabled = false


func disable():
	shape.disabled = true


func is_powered() -> bool:
	return not shape.disabled
