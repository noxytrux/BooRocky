extends Node2D

const PLAYER = preload("res://scenes/player.tscn")
const SIZE := 1.5

@export var cloth_color_modulate := Color.WHITE
@export var hair_color_modulate := Color.WHITE

func spawn_player(parent_node: Node, input_device: GlobalValues.INPUT_DEVICE) -> void:
	var obj = PLAYER.instantiate()
	obj.cloth_color_modulate = cloth_color_modulate
	obj.hair_color_modulate = hair_color_modulate
	obj.input_device = input_device
	parent_node.add_child(obj)
	obj.position = position
	obj.scale = Vector2(SIZE, SIZE)
