extends Area3D

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	print("ENTER AREA READY")

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		print("PLAYER IN TANK AREA")

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
