extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	print(name, "TRIGGER HIT BY", body.name)

	if body.name == "Player":

		get_parent().get_node("MissionManager").start_ambush()

		monitoring = false
		monitorable = false
