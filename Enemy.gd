extends StaticBody3D

var health := 50
var alive := true

var attack_timer := 0.0
var player

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
	print("Enemy HP:", health)

	if health <= 0:
		alive = false
		queue_free()


func _process(delta):
	if !player or !player.alive or !alive:
		return

	attack_timer -= delta

	var direction = (player.global_position - global_position).normalized()
	global_position += direction * 2.0 * delta

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
