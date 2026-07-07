extends Control

func _ready():
	print("TITLE READY")

	await get_tree().create_timer(5.0).timeout

	print("GOING TO YORKTOWN")

	get_tree().change_scene_to_file("res://Instructions.tscn")
