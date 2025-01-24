extends CharacterBody2D

const SPEED := 500.0
@export var color := Color.RED
@export var input_action_left := ""
@export var input_action_right := ""
@export var input_action_up := ""
@export var input_action_down := ""
@export var input_action_1 := ""
@export var input_action_2 := ""
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	polygon_2d.color = color

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector(input_action_left, input_action_right, input_action_up, input_action_down)
	velocity = dir * SPEED
	move_and_slide()
