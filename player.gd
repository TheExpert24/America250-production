extends CharacterBody3D

@export var speed := 5.0

@onready var neck = $Neck

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
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

	var direction = (forward * input_dir.y + right * input_dir.x)

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
