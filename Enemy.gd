extends Node3D

@export var speed := 2.0

var attack_timer := 0.0
var player

func _ready():
	player = get_parent().get_node("Player")

func _process(delta):
	attack_timer -= delta

	if player:
		var direction = (player.global_position - global_position).normalized()

		global_position += direction * speed * delta

		look_at(
			Vector3(
				player.global_position.x,
				global_position.y,
				player.global_position.z
			),
			Vector3.UP
		)

		if global_position.distance_to(player.global_position) < 1.5:
			if attack_timer <= 0:
				player.take_damage(10)
				attack_timer = 1.0
