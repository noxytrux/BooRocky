class_name Adult extends CharacterBody2D

const speed = 120
const accel = 20

@export var destination: Node2D
@onready var nav_agent:= $NavigationAgent2D as NavigationAgent2D
@onready var main_body: AnimatedSprite2D = $main_body

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	if dir.y < -0.8:
		main_body.play("up")
	
	if dir.y > 0.8:
		main_body.play("down")
	
	if dir.x < -0.5:
		main_body.play("left")
	
	if dir.x > 0.5:
		main_body.play("right")		
	
	velocity = velocity.lerp(dir * speed, delta * accel)
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = destination.global_position

func _on_timer_timeout() -> void:
	makepath()
