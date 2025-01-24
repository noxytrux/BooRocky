extends CharacterBody2D

const SPEED := 3000.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("Left", "Right", "Down", "Up")
	print("dir=%s" % dir)
	#var xformed_dir = transform.basis_xform(dir)
	velocity = dir * SPEED * delta
	move_and_slide()
