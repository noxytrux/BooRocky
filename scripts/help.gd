class_name HelpScene extends Node2D

@onready var exit_button: Button = $ExitButton

func _ready() -> void:
	exit_button.visible = SingletonObject.gameplay_running
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		_on_back_button_pressed()
	
func _on_back_button_pressed() -> void:
	if SingletonObject.gameplay_running:
		# This scene is just a node inside Level scene - delete the nodes.
		queue_free()
	else:
		# This scene is the main and only scene - replace it with Menu.
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
