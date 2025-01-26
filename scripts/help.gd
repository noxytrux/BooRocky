class_name HelpScene extends Node2D

@onready var exit_button: Button = $ExitButton
@onready var page_1: Node2D = $Page1
@onready var page_2: Node2D = $Page2

func _ready() -> void:
	exit_button.visible = SingletonObject.gameplay_running
		
func _on_back_button_pressed() -> void:
	SingletonObject.back_from_help()

func _on_exit_button_pressed() -> void:
	SingletonObject.switch_to_menu()

func _on_prev_page_button_pressed() -> void:
	page_1.visible = true
	page_2.visible = false

func _on_next_page_button_pressed() -> void:
	page_2.visible = true
	page_1.visible = false
