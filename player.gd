extends CharacterBody3D

@export var speed := 5.0
var alive := true
var health := 100
var can_shoot := true
var fire_rate := 0.25
@onready var camera = $Neck/Camera3D
@onready var neck = $Neck

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func shoot():
	if !can_shoot:
		return

	can_shoot = false

	# recoil
	rotate_x(deg_to_rad(-1.0))

	# raycast
	var space_state = get_world_3d().direct_space_state
	var start = camera.global_position
	var end = start + (-camera.global_transform.basis.z * 100)

	var query = PhysicsRayQueryParameters3D.create(start, end)
	var result = space_state.intersect_ray(query)

	if result:
		var collider = result["collider"]
		print("HIT:", collider)
		if collider.has_method("take_damage"):
			collider.take_damage(25)
	else:
		print("MISS")

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
func take_damage(amount):
	if !alive:
		return

	health -= amount

	if health < 0:
		health = 0

	print("Health:", health)

	if health <= 0:
		alive = false
		print("YOU DIED")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * 0.0015)

		neck.rotate_x(-event.relative.y * 0.0015)

		neck.rotation.x = clamp(
			neck.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

func _physics_process(delta):
	if !alive:
		return

	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	var forward = -transform.basis.z
	var right = transform.basis.x

	var direction = forward * input_dir.y + right * input_dir.x

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
