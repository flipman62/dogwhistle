extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -500.0
const CAN_JUMP = false

var frozen := true

@onready var ball = get_parent().get_node("Ball")
@onready var sprite = $Sprite
@onready var whistle = get_parent().get_node("Whistle")
@onready var whistle_sound = whistle.get_node("Sound")
@onready var whistle_sprite = whistle.get_node("Sprite")

func _ready() -> void:
	whistle_sound.finished.connect(_on_whistle_finished)

func _on_whistle_finished() -> void:
	whistle_sprite.frame = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("whistle"):
		frozen = not frozen
		velocity = Vector2.ZERO
		whistle_sound.play()
		whistle_sprite.frame = 1

	if not frozen:
		if position.x < ball.position.x - 50:
			velocity.x = SPEED
			sprite.flip_h = false
		elif position.x > ball.position.x + 50:
			velocity.x = -(SPEED)
			sprite.flip_h = true
		else:
			velocity.x = 0

	if Input.is_action_just_pressed("jump") and is_on_floor() and CAN_JUMP:
		velocity.y = JUMP_VELOCITY

	move_and_slide()
