extends Node3D

var direction := Vector3.ZERO

func _process(delta):
	global_position += direction * delta
