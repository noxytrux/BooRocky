extends CharacterBody2D

const SPEED := 500.0
const DASH_SPEED := 1000.0

@export var input_device := GlobalValues.INPUT_DEVICE.WSAD
@export var cloth_color_modulate := Color.WHITE
@export var hair_color_modulate := Color.WHITE

@onready var sprites: Node2D = $Sprites
@onready var animated_sprite_2d_clothes: AnimatedSprite2D = $Sprites/AnimatedSprite2D_Clothes
@onready var animated_sprite_2d_hair: AnimatedSprite2D = $Sprites/AnimatedSprite2D_Hair
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var dash_active_timer: Timer = $DashActiveTimer
@onready var dash_particles: CPUParticles2D = $DashParticles

var direction := GlobalValues.DIRECTION.NONE
var is_input_enabled := false # Disabled during startup.
var is_walking := false
var is_dash_active := false
var is_dash_ready := true

var action1PreviousState
var isAction1JustPressed

@onready var Raycast = $RayCast2D
@export var RayRange = 100.0

var HoldItem: ItemBase
@onready var ItemAnchor = $ItemAnchor

func _ready() -> void:
	reset_color()
	set_animation("walk_down", false)
	
func reset_color() -> void:
	animated_sprite_2d_clothes.modulate = cloth_color_modulate
	animated_sprite_2d_hair.modulate = hair_color_modulate

func Interaction() -> void:
	if(Raycast.is_colliding()):
		var hit =  Raycast.get_collider()
		if (hit is ContainerItem):
			if(HoldItem == null):
				HoldItem = hit.TakeItem()
				if(HoldItem != null):
					ItemAnchor.add_child(HoldItem)
					HoldItem.position = Vector2(0, 0)
					HoldItem.PickUp()
				else:
					var peek = hit.PeekItem()
					if (peek is Baby) && peek.HasDiaper():
						HoldItem = peek.GetDiaper()
						ItemAnchor.add_child(HoldItem)
						HoldItem.position = Vector2(0, 0)
						HoldItem.PickUp()

			elif(hit.CanPlaceItem(HoldItem)):
					HoldItem.PutDown()
					hit.PlaceItem(HoldItem)
					HoldItem = null
			else:
				var item = hit.PeekItem()
				if(item == null):
					return
				if (item is Baby) and (HoldItem != null):		
					if item.Satisfy(HoldItem):
						HoldItem.PutDown()					
						HoldItem = null

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	var action1 := false
	var action2 := false
	if is_input_enabled:
		dir = GlobalValues.GetInputDirection(input_device)
		action1 = GlobalValues.IsInputAction1Pressed(input_device)
		action2 = GlobalValues.IsInputAction2Pressed(input_device)
	# Introduce dead zone.
	var new_is_walking := false
	var new_dir_enum = direction
	if dir.length_squared() > 0.1:
		new_is_walking = true
		dir = dir.normalized()
		new_dir_enum = GlobalValues.direction_vector_to_enum(dir)
	else:
		dir = Vector2.ZERO
	
	# If to set true for action1 input only once per clicked
	if (action1 != action1PreviousState):
		isAction1JustPressed = action1
		action1PreviousState = action1
	else:
		isAction1JustPressed = false
	
	# PickUp
	if (isAction1JustPressed):
		set_animation("pickup_down", true)
		Interaction()
	
	# Dash
	if action2 and is_dash_ready:
		is_dash_active = true
		is_dash_ready = false
		dash_particles.emitting = true
		dash_cooldown_timer.start()
		dash_active_timer.start()
	
	velocity = dir * (SPEED if not is_dash_active else DASH_SPEED)
	move_and_slide()
	
	# Control animation
	if new_is_walking != is_walking or new_dir_enum != direction:
		direction = new_dir_enum
		is_walking = new_is_walking
		SetRaycastDirection()
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

func _on_dash_cooldown_timer_timeout() -> void:
	is_dash_ready = true

func _on_dash_active_timer_timeout() -> void:
	is_dash_active = false
	dash_particles.emitting = false
	
# Called from AnimationPlayer as a callback at the end.
func _on_startup_finished() -> void:
	is_input_enabled = true

func SetRaycastDirection() -> void:
	match direction:
		GlobalValues.DIRECTION.LEFT:
			Raycast.target_position = Vector2.LEFT * RayRange
		GlobalValues.DIRECTION.RIGHT:
			Raycast.target_position = Vector2.RIGHT * RayRange
		GlobalValues.DIRECTION.UP:
			Raycast.target_position = Vector2.UP * RayRange
		GlobalValues.DIRECTION.DOWN:
			Raycast.target_position = Vector2.DOWN * RayRange
