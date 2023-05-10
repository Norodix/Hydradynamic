extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Source/Environment/world.tscn")
	pass # Replace with function body.


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Source/UI/Audio.tscn")
	pass # Replace with function body.


func _on_video_pressed():
	get_tree().change_scene_to_file("res://Source/UI/Video.tscn")
	pass # Replace with function body.


func _on_input_pressed():
	get_tree().change_scene_to_file("res://Source/UI/Input.tscn")
	pass # Replace with function body.


func _on_exit_pressed():
	print("Exiting normally from main menu")
	get_tree().quit(0)
	pass # Replace with function body.
