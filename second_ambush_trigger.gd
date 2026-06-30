extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
	print("SECOND AMBUSH READY")

func _on_body_entered(body):

	print("ENTERED:", body.name)

	if body.name != "Player":
		return

	print("PLAYER ENTERED SECOND AMBUSH")

	get_parent().get_node("MissionManager").start_second_ambush()

	queue_free()
