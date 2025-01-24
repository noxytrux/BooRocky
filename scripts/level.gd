extends Node

# Elements will be removed from the beginning of this array.
@onready var player_spawners = [
	$PlayerSpawners/PlayerSpawner1, $PlayerSpawners/PlayerSpawner2,
	$PlayerSpawners/PlayerSpawner3, $PlayerSpawners/PlayerSpawner4]

# Index matches INPUT_DEVICE. Elements will be set to true.
var player_per_input_device_spawned := [false, false, false, false]

func process_spawning_player(input_device: GlobalValues.INPUT_DEVICE) -> void:
	if GlobalValues.IsInputAction1Pressed(input_device) and not player_per_input_device_spawned[input_device]:
		player_spawners[0].spawn_player(input_device)
		player_per_input_device_spawned[input_device] = true
		player_spawners[0].queue_free()
		player_spawners.remove_at(0)

func _process(delta: float) -> void:
	process_spawning_player(GlobalValues.INPUT_DEVICE.WSAD)
	process_spawning_player(GlobalValues.INPUT_DEVICE.ARROWS)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD1)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD2)
