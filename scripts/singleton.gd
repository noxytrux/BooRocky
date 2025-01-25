class_name Singleton extends Node

const MENU_SCENE = preload("res://scenes/menu.tscn")
const HELP_SCENE = preload("res://scenes/help.tscn")
const LEVEL_SCENE = preload("res://scenes/Level.tscn")

@onready var menu_music_player: AudioStreamPlayer2D = $MenuMusicPlayer
@onready var game_music_player: AudioStreamPlayer2D = $GameMusicPlayer
@onready var button_sound: AudioStreamPlayer2D = $button_sound

var gameplay_running := false
var help_on_top_of_gameplay_node: Node = null

func play_sound() -> void:
	if not button_sound.playing:
		button_sound.play()

func switch_to_scene(path: String) -> void:
	play_sound()
	help_on_top_of_gameplay_node = null
	get_tree().change_scene_to_file(path)
	get_tree().paused = false
	
func switch_to_game() -> void:
	switch_to_scene(LEVEL_SCENE.resource_path)

func switch_to_menu() -> void:
	switch_to_scene(MENU_SCENE.resource_path)

func switch_to_help() -> void:
	switch_to_scene(HELP_SCENE.resource_path)

func back_from_help() -> void:
	if gameplay_running:
		resume_gameplay()
	else:
		switch_to_menu()

func get_scene_node() -> Node:
	# 0th is autoloaded SingletonObject.
	return get_tree().root.get_child(1)

func resume_gameplay() -> void:
	play_sound()
	help_on_top_of_gameplay_node.queue_free()
	help_on_top_of_gameplay_node = null
	get_tree().paused = false

func pause_gameplay_show_help() -> void:
	play_sound()
	assert(gameplay_running)
	assert(help_on_top_of_gameplay_node == null)
	get_tree().paused = true
	help_on_top_of_gameplay_node = HELP_SCENE.instantiate()
	get_scene_node().add_child(help_on_top_of_gameplay_node)
	
func on_escape_pressed() -> void:
	var scene_node = get_scene_node()
	if help_on_top_of_gameplay_node != null:
		assert(is_instance_of(scene_node, LevelScene))
		resume_gameplay()
	elif gameplay_running:
		assert(is_instance_of(scene_node, LevelScene))
		pause_gameplay_show_help()
	elif is_instance_of(scene_node, MenuScene):
		pass # Do nothing.
	elif is_instance_of(scene_node, HelpScene):
		switch_to_menu()
	else:
		assert(false, "Unexpected scene type.")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		on_escape_pressed()

func on_gameplay_started() -> void:
	gameplay_running = true
	menu_music_player.stop()
	game_music_player.play()
	
func on_gameplay_ending() -> void:
	gameplay_running = false
	game_music_player.stop()
	menu_music_player.play()
