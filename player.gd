extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.0
@export var gravity := 20.0

var alive := true
var health := 100

var ads := false
var can_shoot := true
var fire_rate := 0.25

var game_finished := false

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D
@onready var hit_marker = null
@onready var gunshot_sfx = $GunShot


func _ready():
	alive = true
	health = 100

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hit_marker = get_tree().current_scene.get_node("UI/HitMarker")

	print("PLAYER READY - ALIVE =", alive)


func take_damage(amount):
	if !alive or game_finished:
		return

	health -= amount

	if health < 0:
		health = 0

	print("Health:", health)

	if health <= 0:
		alive = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		print("YOU DIED")


func _unhandled_input(event):

	# ALWAYS allow ESC to release mouse
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

	# Block everything else after game ends
	if game_finished:
		return

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			ads = event.pressed

			if ads:
				print("ADS ON")
			else:
				print("ADS OFF")

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

		var sens := 0.0015
		if ads:
			sens = 0.0007

		rotate_y(-event.relative.x * sens)
		neck.rotate_x(-event.relative.y * sens)

		neck.rotation.x = clamp(
			neck.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)


func _physics_process(delta):
	if !alive or game_finished:
		return

	var target_fov := 75.0
	if ads:
		target_fov = 50.0

	camera.fov = lerp(camera.fov, target_fov, 0.2)

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Movement input
	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var forward = -transform.basis.z
	var right = transform.basis.x

	var direction = (
		forward * -input_dir.y +
		right * input_dir.x
	).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()


func shoot():
	if !can_shoot:
		return

	can_shoot = false

	if gunshot_sfx:
		gunshot_sfx.play()

	var bullet_scene = load("res://bullet.glb")

	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		var direction = -camera.global_transform.basis.z

		bullet.name = "Bullet"
		bullet.global_position = camera.global_position + direction * 1.0
		bullet.look_at(
			bullet.global_position + direction,
			Vector3.UP
			)
		bullet.rotation_degrees.x -= 90
		bullet.scale = Vector3(0.003, 0.003, 0.003)
		bullet.set_meta("dir", direction * 80.0)

	var space_state = get_world_3d().direct_space_state

	var start = camera.global_position
	var end = start + (-camera.global_transform.basis.z * 100)

	var query = PhysicsRayQueryParameters3D.create(start, end)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	if result:
		var collider = result["collider"]

		if collider.has_method("take_damage"):
			collider.take_damage(25)

			if collider.has_method("flash"):
				collider.flash()

			if hit_marker:
				hit_marker.visible = true
				hit_marker.scale = Vector2(1.4, 1.4)

				await get_tree().create_timer(0.05).timeout

				hit_marker.visible = false
				hit_marker.scale = Vector2(1.0, 1.0)

	else:
		print("MISS")

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
func _process(delta):
	for child in get_tree().current_scene.get_children():
		if child.name.begins_with("Bullet"):
			if child.has_meta("dir"):
				child.global_position += child.get_meta("dir") * delta
