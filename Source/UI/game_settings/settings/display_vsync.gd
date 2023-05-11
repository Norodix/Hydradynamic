@tool
extends ggsSetting


func _init() -> void:
	name = "Vsync enabled"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle Vsync."
	
	value_type = TYPE_BOOL
	default = true


func apply(value: bool) -> void:
	var vsync_mode = DisplayServer.window_get_vsync_mode()
	match value:
		true:
			vsync_mode = DisplayServer.VSYNC_ENABLED
		false:
			vsync_mode = DisplayServer.VSYNC_DISABLED
	
	DisplayServer.window_set_vsync_mode(vsync_mode)
