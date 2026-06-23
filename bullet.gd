extends Node3D

var velocity := Vector3.ZERO
var lifetime := 2.0

func _ready():
	print("BULLET SCRIPT RUNNING")

func _process(delta):
	global_position += velocity * delta

	lifetime -= delta
	if lifetime <= 0:
		queue_free()
