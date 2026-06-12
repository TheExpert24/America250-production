extends Area3D

var completed := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if completed:
		return

	if body.name != "Player":
		return

	completed = true

	get_parent().get_node("UI/ObjectiveLabel").text = "MISSION COMPLETE!"

	body.game_finished = true

	print("MISSION COMPLETE")

	queue_free()
