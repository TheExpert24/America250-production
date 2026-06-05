extends Node2D

@export var speed := 80

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player:
		var dir = (player.global_position - global_position).normalized()
		position += dir * speed * delta
