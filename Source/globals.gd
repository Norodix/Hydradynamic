extends Node


var player : HydraBody = null

enum layers {
	environment = 0,
	body = 1,
	head = 2,
	button = 3,
	cut = 4,
	remove = 5,
	power_source = 6,
	power_sink = 7,
}

## Settings
var fxaa_enabled : bool = false
var msaa_level : int = 0
