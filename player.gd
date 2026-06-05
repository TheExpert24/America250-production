extends CharacterBody2D

@export var speed := 250
@onready var bullet_scene = preload("res://Bullet.tscn")

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	print("shoot works")

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# FORCE visible position (center of screen)
	bullet.global_position = global_position

	# FORCE visible movement
	bullet.direction = Vector2.RIGHT
