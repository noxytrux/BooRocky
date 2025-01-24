extends Node

func _ready() -> void:
	print("TEST_CONST = %s" % GlobalValues.TEST_CONST)
	print("TEST_ENUM_ITEM2 = %s" % GlobalValues.TEST_ENUM.TEST_ENUM_ITEM2)
	SingletonObject.TestFunction()
	pass

func _process(delta: float) -> void:
	# Exit the entire game.
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()
		return
