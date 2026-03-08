extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var frozen := true

@onready var ball = get_parent().get_node("Ball")
@onready var sprite = $Sprite

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("whistle"):
		frozen = not frozen
		velocity = Vector2.ZERO

	if not frozen:
		# Move horizontally toward the ball, stop when close enough
		var diff = ball.position.x - position.x
		if abs(diff) > 20:
			velocity.x = sign(diff) * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Jump if the ball is significantly above the dog
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
