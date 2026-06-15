extends Node

var stage := 0
var retreat_allowed := false
var time_remaining := 30

@onready var objective_label = get_parent().get_node("UI/ObjectiveLabel")
@onready var timer_label = get_parent().get_node("UI/TimerLabel")

@onready var enemy1 = get_parent().get_node("Enemy1")
@onready var enemy2 = get_parent().get_node("Enemy2")
@onready var enemy3 = get_parent().get_node("Enemy3")


func _ready():

	objective_label.text = "Objective: Investigate the British Rear Guard"

	timer_label.visible = false

	enemy1.visible = false
	enemy2.visible = false
	enemy3.visible = false

	enemy1.process_mode = Node.PROCESS_MODE_DISABLED
	enemy2.process_mode = Node.PROCESS_MODE_DISABLED
	enemy3.process_mode = Node.PROCESS_MODE_DISABLED


func start_ambush():

	if stage != 0:
		return

	stage = 1

	objective_label.text = "AMBUSH! Survive 30 Seconds"

	enemy1.visible = true
	enemy2.visible = true
	enemy3.visible = true

	enemy1.process_mode = Node.PROCESS_MODE_INHERIT
	enemy2.process_mode = Node.PROCESS_MODE_INHERIT
	enemy3.process_mode = Node.PROCESS_MODE_INHERIT

	timer_label.visible = true

	start_survival_timer()


func start_survival_timer():

	time_remaining = 30

	while time_remaining > 0:

		timer_label.text = str(time_remaining)

		await get_tree().create_timer(1.0).timeout

		time_remaining -= 1

	timer_label.text = "0"

	retreat_allowed = true

	objective_label.text = "Retreat to the American Lines"
	var retreat_trigger = get_parent().get_node("RetreatTrigger")

	if retreat_trigger.player_inside:
		complete_mission()

	print("RETREAT AVAILABLE")


func complete_mission():

	print("COMPLETE MISSION CALLED")

	if stage != 1:
		return

	if !retreat_allowed:

		objective_label.text = "Hold Out! Survive the Ambush"

		return

	stage = 2

	timer_label.visible = false

	objective_label.text = "MISSION COMPLETE"

	var player = get_parent().get_node("Player")

	player.game_finished = true

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	print("MISSION COMPLETE")
