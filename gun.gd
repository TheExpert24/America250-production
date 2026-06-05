extends Node3D

@export var sway_strength := 0.02
@export var return_speed := 8.0

var target_rotation := Vector3.ZERO


func _process(delta):
	var mouse_input = Input.get_last_mouse_velocity()

	target_rotation.y = -mouse_input.x * sway_strength
	target_rotation.x = -mouse_input.y * sway_strength

	rotation.x = lerp(rotation.x, target_rotation.x, return_speed * delta)
	rotation.y = lerp(rotation.y, target_rotation.y, return_speed * delta)
