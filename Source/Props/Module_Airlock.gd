extends StaticBody3D
class_name Airlock


signal purge_finished

@onready var entry : AirlockDoor = $Door_Entry
@onready var exit : AirlockDoor = $Door_Exit
@onready var killer : HeadRemover = $HeadRemover

var trap_active = true


func open_entry():
	entry.open()


func close_entry():
	entry.close()


func open_exit():
	exit.open()


func close_exit():
	exit.close()


func purge():
	trap_active = false
	close_exit()
	print("Close exit")
	await exit.close_finished
	print("Close exit done")
	close_entry()
	print("Close entry")
	await entry.close_finished
	print("Close entry done")
	
	killer.enable()
	await get_tree().create_timer(5).timeout
	killer.disable()
	open_exit()
	await exit.open_finished
	emit_signal("purge_finished")


func _on_player_detector_body_entered(body):
	if trap_active:
		purge()
	pass # Replace with function body.


func _on_player_exit_detector_body_exited(body):
	trap_active = true
	pass # Replace with function body.
