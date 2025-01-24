extends CharacterBody2D

const SPEED := 500.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = dir * SPEED
	move_and_slide()
