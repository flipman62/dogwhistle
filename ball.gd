extends RigidBody2D

const MAX_FORCE = 800.0
const CHARGE_RATE = 600.0
const INIT_CHARGE = 200.0

var charge := INIT_CHARGE
var charge_direction := Vector2.ZERO

var _reset_position: Vector2 = Vector2.INF 

func reset_to(pos: Vector2) -> void:
	_reset_position = pos

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if _reset_position != Vector2.INF:
		state.transform = Transform2D(0, _reset_position)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		_reset_position = Vector2.INF

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
