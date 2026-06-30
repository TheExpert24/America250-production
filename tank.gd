extends CharacterBody3D

@export var speed := 7.0
@export var turn_speed := 0.05

var active := false

@onready var enter_area = $EnterArea
@onready var player = get_parent().get_node("Player")
@onready var tank_camera = $CameraMount/Camera3D
@onready var shell_spawn = $ShellSpawn
@onready var tank_shot_audio = $TankShotAudio

var can_fire := true
var reload_time := 1.5
func _physics_process(delta):

	if !active:
		return

	var input := 0.0

	if Input.is_action_pressed("move_forward"):
		input = 1.0

	if Input.is_action_pressed("move_back"):
		input = -1.0

	if input == 0:
		velocity.x = 0
		velocity.z = 0
	else:
		var forward = transform.basis.z
		velocity.x = forward.x * input * speed
		velocity.z = forward.z * input * speed

	move_and_slide()

func player_can_enter():
	return enter_area != null and enter_area.player_inside
func _input(event):

	if !active:
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(event.relative.x * 0.003)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			fire()
func fire():
	tank_shot_audio.play()
	if !can_fire:
		return

	can_fire = false

	var shell_scene = load("res://tankshell.glb")

	if shell_scene:

		var shell = shell_scene.instantiate()
		get_tree().current_scene.add_child(shell)

		var direction = global_transform.basis.z
		direction.y = 0
		direction = direction.normalized()

		shell.name = "TankShell"

		shell.global_position = shell_spawn.global_position + direction * 2.0

		shell.look_at(shell.global_position + direction, Vector3.UP)

		shell.rotation_degrees.x = 90

		shell.scale = Vector3(0.3, 0.3, 0.3)

		shell.set_meta("dir", direction * 150.0)

	await get_tree().create_timer(reload_time).timeout

	can_fire = true
func _process(delta):

	for child in get_tree().current_scene.get_children():

		if child.name.begins_with("TankShell"):

			if child.has_meta("dir"):

				child.global_position += child.get_meta("dir") * delta
