class_name MenuScene extends Node2D
		
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	SingletonObject.switch_to_game()

func _on_help_pressed() -> void:
	SingletonObject.switch_to_help()
