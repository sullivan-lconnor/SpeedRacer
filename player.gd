extends KinematicBody2D

signal reload_scene(time_of_last_goal)

export var max_speed := 3000
export var acceleration := 5000

const DEADZONE := 0.8

var velocity := Vector2.ZERO
var last_input_direction := Vector2.UP

var was_pressed := false  # Tracks button state from last frame

func _process(delta):
	var is_pressed = Input.is_joy_button_pressed(0, 0)  # Replace 1 with your button ID
	if was_pressed and not is_pressed:
		# Button was just released
		emit_signal("reload_scene", -1)
	was_pressed = is_pressed
				
func _physics_process(delta):
	# Get left stick input
	var stick_input := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_0),
		Input.get_joy_axis(0, JOY_AXIS_1)
	)

	# Only update direction if input is strong enough
	if stick_input.length() > DEADZONE:
		last_input_direction = stick_input
		rotation = last_input_direction.angle() + deg2rad(90)  # Sprite faces up

	# Get thrust from right trigger (JOY_AXIS_7)
	var thrust := clamp(Input.get_joy_axis(0, JOY_AXIS_5), 0, 1)

	# Thrust in current facing direction
	var direction := Vector2.UP.rotated(rotation)
	velocity += direction * acceleration * thrust * delta
	velocity = velocity.clamped(max_speed)

	velocity = move_and_slide(velocity)
