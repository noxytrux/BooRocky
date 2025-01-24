extends Node

func _ready() -> void:
	print("TEST_CONST = %s" % GlobalValues.TEST_CONST)
	print("TEST_ENUM_ITEM2 = %s" % GlobalValues.TEST_ENUM.TEST_ENUM_ITEM2)
	pass

func _process(delta: float) -> void:
	pass
