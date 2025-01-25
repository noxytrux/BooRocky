class_name GlobalValues extends Node

enum TEST_ENUM { TEST_ENUM_ITEM1, TEST_ENUM_ITEM2 }

const TEST_CONST := 42

enum INPUT_DEVICE { WSAD, ARROWS, GAMEPAD1, GAMEPAD2 }
enum DIRECTION { NONE, LEFT, RIGHT, UP, DOWN }

static func direction_vector_to_enum(dir: Vector2) -> DIRECTION:
	if not dir:
		return DIRECTION.NONE
	var dir_abs = dir.abs()
	if dir_abs.x > dir_abs.y:
		return DIRECTION.LEFT if dir.x < 0.0 else DIRECTION.RIGHT
	else:
		return DIRECTION.UP if dir.y < 0.0 else DIRECTION.DOWN

static func direction_to_str(dir: DIRECTION) -> String:
	match dir:
		DIRECTION.LEFT:
			return "left"
		DIRECTION.RIGHT:
			return "right"
		DIRECTION.UP:
			return "up"
		DIRECTION.DOWN:
			return "down"
	return "none"

static func GetInputDirection(input_device: INPUT_DEVICE) -> Vector2:
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			return Input.get_vector("A", "D", "W", "S")
		GlobalValues.INPUT_DEVICE.ARROWS:
			return Input.get_vector("Left", "Right", "Up", "Down")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			return Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			return Vector2(Input.get_joy_axis(1, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(1, JOY_AXIS_LEFT_Y))
	return Vector2.ZERO

static func IsInputAction1Pressed(input_device: INPUT_DEVICE) -> bool:
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			return Input.is_action_pressed("Q")
		GlobalValues.INPUT_DEVICE.ARROWS:
			return Input.is_action_pressed("Dot")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			return Input.is_joy_button_pressed(0, JOY_BUTTON_A)
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			return Input.is_joy_button_pressed(1, JOY_BUTTON_A)
	return false

static func IsInputAction2Pressed(input_device: INPUT_DEVICE) -> bool:
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			return Input.is_action_pressed("E")
		GlobalValues.INPUT_DEVICE.ARROWS:
			return Input.is_action_pressed("Slash")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			return Input.is_joy_button_pressed(0, JOY_BUTTON_X)
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			return Input.is_joy_button_pressed(1, JOY_BUTTON_X)
	return false

static func progress_to_color(progress: float) -> Color:
	if progress < 0.5:
		# 0% red to 50% yellow.
		return Color.RED.lerp(Color.YELLOW, progress * 2.0)
	else:
		#50% yellow to 100% green.
		return Color.YELLOW.lerp(Color.GREEN, (progress - 0.5) * 2.0)
