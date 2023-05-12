extends StaticBody3D
class_name Airlock


signal purge_finished

@onready var entry : AirlockDoor = $Door_Entry
@onready var exit : AirlockDoor = $Door_Exit
@onready var killer : HeadRemover = $HeadRemover

var trap_active = true
var has_purged = false
var purge_in_progress = false


func open_entry():
	if purge_in_progress:
		return
	entry.open()


func close_entry():
	entry.close()


func open_exit():
	if purge_in_progress:
		return
	exit.open()


func close_exit():
	exit.close()


func purge():
	purge_in_progress = true
	trap_active = false
	close_exit()
	print("Close exit")
	await wait_for_close(exit)
	print("Close exit done")
	close_entry()
	print("Close entry")
	await wait_for_close(entry)
	print("Close entry done")
	
	if $PlayerExitDetector.has_overlapping_bodies():
		for burner in $Burners.get_children():
			if burner.has_method("start"):
				burner.start()
		await get_tree().create_timer(0.5).timeout
		
		killer.enable()
		await get_tree().create_timer(5).timeout
		killer.disable()
		emit_signal("purge_finished")
		has_purged = true
		
		for burner in $Burners.get_children():
			if burner.has_method("stop"):
				burner.stop()
		await get_tree().create_timer(0.5).timeout
	
	purge_in_progress = false
	
	if has_purged:
		open_exit()
		await wait_for_open(exit)


func _on_player_detector_body_entered(body):
	if trap_active:
		purge()
	pass # Replace with function body.


func _on_player_exit_detector_body_exited(body):
	trap_active = true
	pass # Replace with function body.


func wait_for_close(door : AirlockDoor, timeout = 5):
	var timestep = 0.1
	var time_passed = 0.0
	
	while time_passed < timeout:
		time_passed += timestep
		if door.is_open:
			door.close()
		if door.is_closed:
			return
		await get_tree().create_timer(timestep).timeout


func wait_for_open(door : AirlockDoor, timeout = 5):
	var timestep = 0.1
	var time_passed = 0.0
	
	while time_passed < timeout:
		time_passed += timestep
		if door.is_closed:
			door.open()
		if door.is_open:
			return
		await get_tree().create_timer(timestep).timeout
