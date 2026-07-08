extends StaticBody3D

var health := 50
var alive := true

var attack_timer := 0.0
var player

var retreating := false
var retreat_timer := 0.0

var formation_offset := Vector3.ZERO

var shoot_range := 15.0
var shoot_cooldown := 4.0

@onready var mesh = $MeshInstance3D


func _ready():
	player = get_parent().get_node("Player")

	formation_offset = Vector3(
		randf_range(-4.0, 4.0),
		0,
		randf_range(-4.0, 4.0)
	)


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
		var player = get_parent().get_node("Player")
		if player:
			player.kills += 1
			player.kill_label.text = "Kills: " + str(player.kills)
		queue_free()


func _process(delta):
	if !player:
		return

	if !player.alive:
		return

	if !alive:
		return

	if player.game_finished:
		return

	attack_timer -= delta

	var target_position = player.global_position + formation_offset

	var direction = (
		target_position - global_position
	).normalized()

	look_at(
		Vector3(
			target_position.x,
			global_position.y,
			target_position.z
		),
		Vector3.UP
	)

	if retreating:

		retreat_timer -= delta

		global_position -= direction * 1.0 * delta

		if retreat_timer <= 0:
			retreating = false

	else:

		if global_position.distance_to(player.global_position) > shoot_range:
			global_position += direction * 3.5 * delta

	if global_position.distance_to(player.global_position) <= shoot_range:

		if attack_timer <= 0:

			player.take_damage(3)

			print("BRITISH FIRED")

			attack_timer = shoot_cooldown
