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
@onready var enemy4 = get_parent().get_node("Enemy4")
@onready var enemy5 = get_parent().get_node("Enemy5")
@onready var enemy6 = get_parent().get_node("Enemy6")
@onready var enemy7 = get_parent().get_node("Enemy7")
@onready var enemy8 = get_parent().get_node("Enemy8")

@onready var enemy9 = get_parent().get_node("Enemy9")
@onready var enemy10 = get_parent().get_node("Enemy10")
@onready var enemy11 = get_parent().get_node("Enemy11")
@onready var enemy12 = get_parent().get_node("Enemy12")
@onready var enemy13 = get_parent().get_node("Enemy13")
@onready var enemy14 = get_parent().get_node("Enemy14")
@onready var enemy15 = get_parent().get_node("Enemy15")
@onready var enemy16 = get_parent().get_node("Enemy16")

@onready var retreat_trigger = get_parent().get_node("RetreatTrigger")
@onready var player = get_parent().get_node("Player")
@onready var tank = get_parent().get_node("Tank")

func _ready():
	reset_mission()

func reset_mission():
	stage = 0
	retreat_allowed = false
	time_remaining = 30.0
	timer_id += 1

	timer_label.visible = false
	timer_label.text = ""

	objective_label.text = "General George Washington wants us to head to the palm tree at the end of the road near the base. Go check it out."

	_set_enemies(false)
	_set_second_enemies(false)

	if tank:
		tank.visible = false
		tank.active = false

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func palm_tree_found():
	if stage != 0:
		return

	stage = 1

	objective_label.text = "General Washington found this weapon last night. It has 'M1 Abrams' written on it.\nWe think it is from the future. You can either use this 'glitch' or your musket. Press E to enter it and left click to shoot. Head to the British Camp."

	if tank:
		tank.visible = true
		tank.active = false

	print("TANK UNLOCKED")

func start_ambush():
	if stage != 1:
		return

	stage = 2
	retreat_allowed = false
	time_remaining = 30.0
	timer_id += 1

	objective_label.text = "AMBUSH! The British soldiers have come. Survive 30 seconds."
	timer_label.visible = true

	_set_enemies(true)

	start_timer(timer_id)

func start_timer(id):
	while stage == 2 and time_remaining > 0 and id == timer_id:
		timer_label.text = str(int(time_remaining))
		await get_tree().create_timer(1.0).timeout
		time_remaining -= 1

	if id != timer_id:
		return

	if stage != 2:
		return

	timer_label.text = "0"
	retreat_allowed = true
	objective_label.text = "Head to the town of York. The British have control over it."

func _process(_delta):

	if stage == 2 and retreat_allowed:
		if retreat_trigger.player_inside:
			start_second_ambush()

	if stage == 3:
		var enemies = [
			enemy9, enemy10, enemy11, enemy12,
			enemy13, enemy14, enemy15, enemy16
		]

		var alive := false

		for e in enemies:
			if is_instance_valid(e) and e.visible:
				alive = true
				break

		if !alive:
			complete_second_ambush()

	if stage == 4:
		if retreat_trigger.player_inside:
			base_arrived()
func start_second_ambush():
	if stage != 2:
		return

	stage = 3

	objective_label.text = "Cornwallis has sent a second squadron of soldiers to York. Show them what America is made of."

	_set_second_enemies(true)

	print("SECOND AMBUSH STARTED")

func complete_second_ambush():
	if stage != 3:
		return

	stage = 4

	objective_label.text = "We've got the British. Head back to the base."

func base_arrived():
	if stage != 4:
		return

	stage = 5

	objective_label.text = "The British have surrendered.\nThe war is over, and we are now the United States of America."

	player.game_finished = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _set_enemies(state: bool):
	var enemies = [enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8]

	for enemy in enemies:
		enemy.visible = state
		enemy.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED

func _set_second_enemies(state: bool):
	var enemies = [enemy9, enemy10, enemy11, enemy12, enemy13, enemy14, enemy15, enemy16]

	for enemy in enemies:
		enemy.visible = state
		enemy.process_mode = Node.PROCESS_MODE_INHERIT if state else Node.PROCESS_MODE_DISABLED
