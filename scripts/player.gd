extends CharacterBody2D

const SPEED := 500.0

@export var input_device := GlobalValues.INPUT_DEVICE.WSAD
@export var color := Color.RED

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var animation_player: AnimationPlayer = $Polygon2D/AnimationPlayer
@onready var sprites: Node2D = $Sprites

var direction := GlobalValues.DIRECTION.NONE
var HoldItem: ItemBase

func _ready() -> void:
	reset_color()
	set_direction(GlobalValues.DIRECTION.LEFT)
	
func reset_color() -> void:
	polygon_2d.color = color

func _process(delta: float) -> void:
	Interaction();

func Interaction() -> void:
	if(Input.is_action_just_pressed("E") && $RayCast2D.is_colliding()):
		var hit = $RayCast2D.get_collider()
		if (hit is ContainerItem):
			if(HoldItem == null):
				HoldItem = hit.TakeItem()
				if(HoldItem != null):
					self.add_child(HoldItem)
					print(HoldItem.get_parent())
					HoldItem.position = Vector2(0, 0)
			else:
					hit.PlaceItem(HoldItem)
					HoldItem = null

func set_direction(new_dir: GlobalValues.DIRECTION) -> void:
	if new_dir != direction:
		direction = new_dir
		for animated_sprite in sprites.get_children():
			assert(is_instance_of(animated_sprite, AnimatedSprite2D))
			match new_dir:
				GlobalValues.DIRECTION.LEFT:
					animated_sprite.play("walk_left")
				GlobalValues.DIRECTION.RIGHT:
					animated_sprite.play("walk_right")
				GlobalValues.DIRECTION.UP:
					animated_sprite.play("walk_up")
				GlobalValues.DIRECTION.DOWN:
					animated_sprite.play("walk_down")

func _physics_process(delta: float) -> void:
	var dir = Vector2.ZERO
	var action1 := false
	var action2 := false
	match input_device:
		GlobalValues.INPUT_DEVICE.WSAD:
			dir = Input.get_vector("A", "D", "W", "S")
			action1 = Input.is_action_pressed("Q")
			action2 = Input.is_action_pressed("E")
		GlobalValues.INPUT_DEVICE.ARROWS:
			dir = Input.get_vector("Left", "Right", "Up", "Down")
			action1 = Input.is_action_pressed("Dot")
			action2 = Input.is_action_pressed("Slash")
		GlobalValues.INPUT_DEVICE.GAMEPAD1:
			dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
			action1 = Input.is_joy_button_pressed(0, JOY_BUTTON_A)
			action2 = Input.is_joy_button_pressed(0, JOY_BUTTON_X)
		GlobalValues.INPUT_DEVICE.GAMEPAD2:
			dir = Vector2(Input.get_joy_axis(1, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(1, JOY_AXIS_LEFT_Y))
			action1 = Input.is_joy_button_pressed(1, JOY_BUTTON_A)
			action2 = Input.is_joy_button_pressed(1, JOY_BUTTON_X)
	# Introduce dead zone.
	if dir.length_squared() > 0.1:
		dir = dir.normalized()
		var dir_enum = GlobalValues.direction_vector_to_enum(dir)
		set_direction(dir_enum)
	else:
		dir = Vector2.ZERO
	velocity = dir * SPEED
	if action1:
		animation_player.play("Action1")
	move_and_slide()
