class_name LevelScene extends Node

@onready var player_spawners_node: Node2D = $PlayerSpawners
@onready var hide_baner_timer: Timer = $HideBanerTimer

# Elements will be removed from the beginning of this array.
@onready var player_spawners = [
	$PlayerSpawners/PlayerSpawner1, $PlayerSpawners/PlayerSpawner2,
	$PlayerSpawners/PlayerSpawner4, $PlayerSpawners/PlayerSpawner3]

# Index matches INPUT_DEVICE. Elements will be set to true.
var player_per_input_device_spawned := [false, false, false, false]

@onready var player_banner_join = [
	$JoinBaner, $JoinBaner2,
	$JoinBaner3, $JoinBaner4]

func _ready() -> void:
	hide_baner_timer.start()

func process_spawning_player(input_device: GlobalValues.INPUT_DEVICE) -> void:
	if GlobalValues.IsInputAction1Pressed(input_device) and not player_per_input_device_spawned[input_device]:
		player_spawners[0].spawn_player(player_spawners_node, input_device)
		player_per_input_device_spawned[input_device] = true
		create_tween().tween_property(player_banner_join[input_device], "position:y", 1200, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		player_spawners[0].queue_free()
		player_spawners.remove_at(0)

func _process(_delta: float) -> void:
	process_spawning_player(GlobalValues.INPUT_DEVICE.WSAD)
	process_spawning_player(GlobalValues.INPUT_DEVICE.ARROWS)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD1)
	process_spawning_player(GlobalValues.INPUT_DEVICE.GAMEPAD2)

func _on_tree_entered() -> void:
	SingletonObject.on_gameplay_started()

func _on_tree_exiting() -> void:
	SingletonObject.on_gameplay_ending()

func _on_hide_baner_timer_timeout() -> void:
	for baner in player_banner_join:
		create_tween().tween_property(baner, "position:y", 1200, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
