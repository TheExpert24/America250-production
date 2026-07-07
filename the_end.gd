extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event):

	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Instructions.tscn")
