extends Node2D

@onready var enemy_scene = preload("res://Enemy.tscn")

func _ready():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(600, 200)
