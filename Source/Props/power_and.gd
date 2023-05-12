extends Node3D

signal activate
signal deactivate

var active : bool = false
var was_active : bool = false

func _process(delta):
	var all_powered = true
	for child in get_children():
		if child.has_method("is_powered"):
			all_powered = child.is_powered() and all_powered
	active = all_powered
	
	if active and not was_active:
		emit_signal("activate")
	if was_active and not active:
		emit_signal("deactivate")
	was_active = active

func is_powered() -> bool:
	return active
