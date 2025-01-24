extends CharacterBody2D

const SPEED := 500.0

@export var input_device := GlobalValues.INPUT_DEVICE.WSAD
@export var color := Color.RED

@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	polygon_2d.color = color

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			dir = Input.get_vector("A", "D", "W", "S")
		GlobalValues.INPUT_DEVICE.ARROWS:
			dir = Input.get_vector("Left", "Right", "Up", "Down")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			dir = Vector2(Input.get_joy_axis(1, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(1, JOY_AXIS_LEFT_Y))
	# Introduce dead zone.
	if dir.length_squared() > 0.1:
		dir = dir.normalized()
	else:
		dir = Vector2.ZERO
	velocity = dir * SPEED
	move_and_slide()
