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
