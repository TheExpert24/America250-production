extends Area3D

var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if triggered:
		return

	if body.name == "Player":

		triggered = true

		get_parent().get_parent().get_node("MissionManager").palm_tree_found()
