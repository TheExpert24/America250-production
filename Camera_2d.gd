extends Camera2D

@export var follow_strength := 0.1

func _process(delta):
	global_position = global_position.lerp(get_parent().global_position, follow_strength)
