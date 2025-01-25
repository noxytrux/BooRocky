class_name Singleton extends Node

const MENU_SCENE = preload("res://scenes/menu.tscn")
const HELP_SCENE = preload("res://scenes/help.tscn")
const LEVEL_SCENE = preload("res://scenes/Level.tscn")

# Controlled by Level scene on_tree_entered/on_tree_exiting.
var gameplay_running := false

var help_on_top_of_gameplay := false

func switch_to_game() -> void:
	get_tree().change_scene_to_file(LEVEL_SCENE.resource_path)

func switch_to_menu() -> void:
	get_tree().change_scene_to_file(MENU_SCENE.resource_path)

func switch_to_help() -> void:
	get_tree().change_scene_to_file(HELP_SCENE.resource_path)

func back_from_help() -> void:
	if gameplay_running:
		resume_gameplay()
	else:
		switch_to_menu()

func get_scene_node() -> Node:
	# 0th is autoloaded SingletonObject.
	return get_tree().root.get_child(1)

func resume_gameplay() -> void:
	var scene_node = get_scene_node()
	var help_scene_node = scene_node.find_child("Help")
	assert(help_scene_node != null)
	help_scene_node.queue_free()
	help_on_top_of_gameplay = false

func pause_gameplay_show_help() -> void:
	help_on_top_of_gameplay = true
	var help_node = HELP_SCENE.instantiate()
	get_scene_node().add_child(help_node)
	
func on_escape_pressed() -> void:
	var scene_node = get_scene_node()
	if help_on_top_of_gameplay:
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
