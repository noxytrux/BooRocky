class_name MenuScene extends Node2D

@onready var button_sound: AudioStreamPlayer2D = $button_sound

func play_sound(sound: AudioStreamPlayer2D) -> void:
	if not sound.playing:
		sound.play()
		
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	play_sound(button_sound)
	SingletonObject.switch_to_game()

func _on_help_pressed() -> void:
	play_sound(button_sound)
	SingletonObject.switch_to_help()
