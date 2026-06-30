extends CharacterBody3D

@export var speed := 7.0
@export var turn_speed := 0.05

var active := false

@onready var enter_area = $EnterArea
@onready var player = get_parent().get_node("Player")
@onready var tank_camera = $CameraMount/Camera3D
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
func _unhandled_input(event):

	if !active:
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(event.relative.x * 0.003)
