@tool
extends ggsSetting


func _init() -> void:
	name = "FXAA"
	icon = preload("res://addons/ggs/assets/game_settings/display_fullscreen.svg")
	desc = "Toggle fast approximate antialiasing"
	
	value_type = TYPE_BOOL
	default = true


func apply(value: bool) -> void:
	Globals.fxaa_enabled = value
