extends Node2D

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/help.tscn")
