extends StaticBody3D

var health := 50
var alive := true

var attack_timer := 0.0
var player

var retreating := false
var retreat_timer := 0.0

@onready var mesh = $MeshInstance3D


func _ready():
	player = get_parent().get_node("Player")


func flash():
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mesh.material_override = mat

	await get_tree().create_timer(0.1).timeout

	mesh.material_override = null


func take_damage(amount):
	if !alive:
		return

	health -= amount

	retreating = true
	retreat_timer = 1.0

	print("Enemy HP:", health)

	if health <= 0:
		alive = false
		queue_free()


func _process(delta):
	if !player or !player.alive or !alive or player.game_finished:
		return

	attack_timer -= delta

	if retreating:

		retreat_timer -= delta

		var dir = (global_position - player.global_position).normalized()
		global_position += dir * 1.0 * delta

		if retreat_timer <= 0:
			retreating = false

	else:

		var dir = (player.global_position - global_position).normalized()
		global_position += dir * 2.0 * delta

	look_at(
		Vector3(
			player.global_position.x,
			global_position.y,
			player.global_position.z
		),
		Vector3.UP
	)

	if player.game_finished:
		return

	if global_position.distance_to(player.global_position) < 1.5:
		if attack_timer <= 0:
			player.take_damage(10)
			attack_timer = 1.0
