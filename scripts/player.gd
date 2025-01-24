extends CharacterBody2D

const SPEED := 500.0

@export var input_device := GlobalValues.INPUT_DEVICE.WSAD
@export var color := Color.RED

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var animation_player: AnimationPlayer = $Polygon2D/AnimationPlayer

func _ready() -> void:
	reset_color()
	
func reset_color() -> void:
	polygon_2d.color = color

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	var action1 := false
	var action2 := false
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			dir = Input.get_vector("A", "D", "W", "S")
			action1 = Input.is_action_pressed("Q")
			action2 = Input.is_action_pressed("E")
		GlobalValues.INPUT_DEVICE.ARROWS:
			dir = Input.get_vector("Left", "Right", "Up", "Down")
			action1 = Input.is_action_pressed("Dot")
			action2 = Input.is_action_pressed("Slash")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
			action1 = Input.is_joy_button_pressed(0, JOY_BUTTON_A)
			action2 = Input.is_joy_button_pressed(0, JOY_BUTTON_X)
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			dir = Vector2(Input.get_joy_axis(1, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(1, JOY_AXIS_LEFT_Y))
			action1 = Input.is_joy_button_pressed(1, JOY_BUTTON_A)
			action2 = Input.is_joy_button_pressed(1, JOY_BUTTON_X)
	# Introduce dead zone.
	if dir.length_squared() > 0.1:
		dir = dir.normalized()
	else:
		dir = Vector2.ZERO
	velocity = dir * SPEED
	if action1:
		animation_player.play("Action1")
	move_and_slide()
