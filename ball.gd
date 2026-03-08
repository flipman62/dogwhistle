extends RigidBody2D

const MAX_FORCE = 800.0
const CHARGE_RATE = 600.0  # power gained per second of holding
const INIT_CHARGE = 200.0  # minimum power applied on tap

var charge := INIT_CHARGE
var charge_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var released = (Input.is_action_just_released("right") or Input.is_action_just_released("left")
		or Input.is_action_just_released("up") or Input.is_action_just_released("down"))
	if released:
		apply_central_impulse(-charge_direction * charge)
		charge = INIT_CHARGE
		charge_direction = Vector2.ZERO
		return

	var direction := Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		charge_direction = direction.normalized()
		charge = min(charge + CHARGE_RATE * delta, MAX_FORCE)
