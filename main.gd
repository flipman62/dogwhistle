extends Node2D

@onready var dog = $Dog
@onready var ball = $Ball

const LEVELS = [
	preload("res://levels/level1.tscn"),
	preload("res://levels/level2.tscn"),
	preload("res://levels/level3.tscn"),
	preload("res://levels/level4.tscn"),
]

const DOG_START_POS = [
	Vector2(750, 350),
	Vector2(100, 300),
	Vector2(100, 600),
	Vector2(100, 80),
]
const BALL_START_POS = [
	Vector2(850, 600),
	Vector2(300, 300),
	Vector2(200, 600),
	Vector2(100, 600),
]

var current_level_index = 0
var current_level = null

@onready var manager = $LevelManager
@onready var button = $NextButton
@onready var endscreen = $EndScreen
@onready var whistle = $Whistle
@onready var theme = $Theme

func next_level() -> void:
	button.visible = false

	if current_level:
		current_level.queue_free()
		await get_tree().process_frame
		if current_level_index >= LEVELS.size():
			whistle.visible = false
			endscreen.visible = true
			dog.visible = false
			ball.visible = false
			return  


	dog.frozen = true
	dog.velocity = Vector2.ZERO
	dog.position = DOG_START_POS[current_level_index]

	ball.reset_to(BALL_START_POS[current_level_index])

	current_level = LEVELS[current_level_index].instantiate()
	manager.add_child(current_level)

	current_level_index += 1

	var flag = current_level.get_node("Flag")
	flag.reached_flag.connect(show_button)

func show_button() -> void:
	button.visible = true

func restart() -> void:
	current_level_index -= 1
	next_level()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart()

	if theme.playing == false:
		theme.play()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	endscreen.visible = false
	button.visible = false
	button.pressed.connect(next_level)
	next_level()
