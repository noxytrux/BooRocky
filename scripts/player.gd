extends CharacterBody2D

const SPEED := 500.0

@export var input_device := GlobalValues.INPUT_DEVICE.WSAD
@export var cloth_color_modulate := Color.WHITE
@export var hair_color_modulate := Color.WHITE

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var sprites: Node2D = $Sprites
@onready var animated_sprite_2d_clothes: AnimatedSprite2D = $Sprites/AnimatedSprite2D_Clothes
@onready var animated_sprite_2d_hair: AnimatedSprite2D = $Sprites/AnimatedSprite2D_Hair

var direction := GlobalValues.DIRECTION.NONE
var is_walking := false

@onready var Raycast = $RayCast2D

var HoldItem: ItemBase
@onready var ItemAnchor = $ItemAnchor

func _ready() -> void:
	reset_color()
	set_animation("walk_down", false)
	
func reset_color() -> void:
	animated_sprite_2d_clothes.modulate = cloth_color_modulate
	animated_sprite_2d_hair.modulate = hair_color_modulate

func _process(delta: float) -> void:
	Interaction();

func Interaction() -> void:
	if(Input.is_action_just_pressed("E") && Raycast.is_colliding()):
		var hit =  Raycast.get_collider()
		if (hit is ContainerItem):
			if(HoldItem == null):
				HoldItem = hit.TakeItem()
				if(HoldItem != null):
					ItemAnchor.add_child(HoldItem)
					print(HoldItem.get_parent())
					HoldItem.position = Vector2(0, 0)
			else:
					hit.PlaceItem(HoldItem)
					HoldItem = null

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
	var new_is_walking := false
	var new_dir_enum = direction
	if dir.length_squared() > 0.1:
		new_is_walking = true
		dir = dir.normalized()
		new_dir_enum = GlobalValues.direction_vector_to_enum(dir)
	else:
		dir = Vector2.ZERO
		
	# TEMP - pickup animation
	if action1:
		set_animation("pickup_down", true)
	
	velocity = dir * SPEED
	move_and_slide()
	
	# Control animation
	if new_is_walking != is_walking or new_dir_enum != direction:
		direction = new_dir_enum
		is_walking = new_is_walking
		var anim_name := "walk_" if not HoldItem else "carry_"
		anim_name += GlobalValues.direction_to_str(new_dir_enum)
		set_animation(anim_name, new_is_walking)
	
func set_animation(anim_name: String, play: bool) -> void:
	for animated_sprite in sprites.get_children():
		if play:
			animated_sprite.play(anim_name)
		else:
			animated_sprite.animation = anim_name
			animated_sprite.stop()
			animated_sprite.frame = 0
