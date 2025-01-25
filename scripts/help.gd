class_name HelpScene extends Node2D

@onready var exit_button: Button = $ExitButton

func init(is_playing: bool) -> void:
	exit_button.visible = is_playing
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_exit_button_pressed() -> void:
	pass
