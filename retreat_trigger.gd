extends Area3D

var player_inside := false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_inside = true
		print("PLAYER ENTERED RETREAT")

func _on_body_exited(body):
	if body.name == "Player":
		player_inside = false
		print("PLAYER LEFT RETREAT")
