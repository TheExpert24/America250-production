extends Area3D

var completed := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if completed:
		return

	if body.name == "Player":
		completed = true
		print("MISSION COMPLETE")
