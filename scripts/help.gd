class_name HelpScene extends Node2D

@onready var exit_button: Button = $ExitButton
@onready var button_sound: AudioStreamPlayer2D = $button_sound

func _ready() -> void:
	exit_button.visible = SingletonObject.gameplay_running
	
func play_sound(sound: AudioStreamPlayer2D) -> void:
	if not sound.playing:
		sound.play()
	
func _on_back_button_pressed() -> void:
	play_sound(button_sound)
	SingletonObject.back_from_help()

func _on_exit_button_pressed() -> void:
	play_sound(button_sound)
	SingletonObject.switch_to_menu()
