extends Area3D

var player_inside := false

func _ready():
	player_inside = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	print("RETREAT READY")

func _on_body_entered(body):
	print("ENTERED:", body.name)

	if body.name == "Player":
		player_inside = true
		print("PLAYER ENTERED RETREAT")

func _on_body_exited(body):
	print("EXITED:", body.name)

	if body.name == "Player":
		player_inside = false
		print("PLAYER LEFT RETREAT")
