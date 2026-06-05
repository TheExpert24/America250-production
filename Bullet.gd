extends Area2D

var direction = Vector2.ZERO
@export var speed = 300

func _process(delta):
	position += direction * speed * delta
