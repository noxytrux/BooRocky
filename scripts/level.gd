extends Node

@onready var player_spawners_node: Node2D = $PlayerSpawners

# Elements will be removed from the beginning of this array.
@onready var player_spawners = [
	$PlayerSpawners/PlayerSpawner1, $PlayerSpawners/PlayerSpawner2,
	$PlayerSpawners/PlayerSpawner3, $PlayerSpawners/PlayerSpawner4]

# Index matches INPUT_DEVICE. Elements will be set to true.
var player_per_input_device_spawned := [false, false, false, false]

func process_spawning_player(input_device: GlobalValues.INPUT_DEVICE) -> void:
	if GlobalValues.IsInputAction1Pressed(input_device) and not player_per_input_device_spawned[input_device]:
		player_spawners[0].spawn_player(player_spawners_node, input_device)
		player_per_input_device_spawned[input_device] = true
		player_spawners[0].queue_free()
		player_spawners.remove_at(0)

func _process(_delta: float) -> void:
	process_spawning_player(GlobalValues.INPUT_DEVICE.WSAD)
	process_spawning_player(GlobalValues.INPUT_DEVICE.ARROWS)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD1)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD2)
	if Input.is_action_just_pressed("Escape"):
		var help_scene = preload("res://scenes/help.tscn")
		var help_obj = help_scene.instantiate()
		add_child(help_obj)

func _on_tree_entered() -> void:
	SingletonObject.gameplay_running = true

func _on_tree_exiting() -> void:
	SingletonObject.gameplay_running = false
