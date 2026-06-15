extends Node

var stage := 0
var retreat_allowed := false
var time_remaining := 30.0
var timer_id := 0

@onready var objective_label = get_parent().get_node("UI/ObjectiveLabel")
@onready var timer_label = get_parent().get_node("UI/TimerLabel")

@onready var enemy1 = get_parent().get_node("Enemy1")
@onready var enemy2 = get_parent().get_node("Enemy2")
@onready var enemy3 = get_parent().get_node("Enemy3")

@onready var retreat_trigger = get_parent().get_node("RetreatTrigger")
@onready var player = get_parent().get_node("Player")

func _ready():
	reset_mission()

func reset_mission():
	stage = 0
	retreat_allowed = false
	time_remaining = 30.0
	timer_id += 1

	timer_label.visible = false
	timer_label.text = ""

	objective_label.text = "Objective: Investigate the British Rear Guard"

	_set_enemies(false)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print("MISSION RESET")

func _set_enemies(state: bool):
	enemy1.visible = state
	enemy2.visible = state
	enemy3.visible = state

	enemy1.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED
	enemy2.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED
	enemy3.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED

func start_ambush():
	if stage != 0:
		return

	stage = 1
	retreat_allowed = false
	time_remaining = 30.0
	timer_id += 1

	objective_label.text = "AMBUSH! Survive 30 Seconds"
	timer_label.visible = true

	_set_enemies(true)

	print("AMBUSH STARTED")

	start_timer(timer_id)

func start_timer(id):
	while stage == 1 and time_remaining > 0 and id == timer_id:
		timer_label.text = str(int(time_remaining))
		await get_tree().create_timer(1.0).timeout
		time_remaining -= 1

	if id != timer_id:
		return

	timer_label.text = "0"

	if stage != 1:
		return

	retreat_allowed = true
	objective_label.text = "Retreat to the American Lines"

	print("RETREAT AVAILABLE")

func _process(_delta):
	if stage != 1:
		return

	if !retreat_allowed:
		return

	if retreat_trigger.player_inside:
		complete_mission()

func complete_mission():
	if stage != 1:
		return

	stage = 2

	timer_label.visible = false

	objective_label.text = "MISSION COMPLETE"

	player.game_finished = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	print("MISSION COMPLETE")
