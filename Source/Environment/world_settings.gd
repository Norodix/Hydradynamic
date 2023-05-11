extends Node3D

func _ready():
	var viewport = get_viewport()
	viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if Globals.fxaa_enabled else Viewport.SCREEN_SPACE_AA_DISABLED
	viewport.msaa_3d = Globals.msaa_level
