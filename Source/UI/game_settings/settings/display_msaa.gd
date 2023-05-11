@tool
extends ggsSetting

var sizes : Array[int] = [Viewport.MSAA_DISABLED, \
						Viewport.MSAA_2X, \
						Viewport.MSAA_4X, \
						Viewport.MSAA_8X]

func _init() -> void:
	name = "MSAA"
	icon = preload("res://addons/ggs/assets/game_settings/display_size.svg")
	desc = "Apply different levels of Multisample Anti-aliasing"
	
	value_type = TYPE_INT
	value_hint = PROPERTY_HINT_ENUM
	value_hint_string = ",".join(sizes)
	default = Viewport.MSAA_DISABLED


func apply(value: int) -> void:
	Globals.msaa_level = value

