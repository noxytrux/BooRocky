class_name HelpScene extends Node2D

@onready var exit_button: Button = $ExitButton

func _ready() -> void:
	exit_button.visible = SingletonObject.gameplay_running
		
func _on_back_button_pressed() -> void:
	SingletonObject.back_from_help()

func _on_exit_button_pressed() -> void:
	SingletonObject.switch_to_menu()
