class_name ContainerItem extends Node2D

@export var HoldItem: ItemBase
@onready var ItemAnchor = $ItemAnchor
@onready var take_put_sound: AudioStreamPlayer2D = $take_put_sound
@onready var arrow: Sprite2D = $arrow

func _ready() -> void:
	PlaceItem(HoldItem) #ONLY FOR TEST - DELETE THIS LATER
	setArrow()

func setArrow() -> void:
	await arrow
	
	if arrow == null:
		return
	
	var move_speed = 0.3
	var start_y := arrow.position.y
	var end_y := arrow.position.y + 10
	var tween := create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow, "position:y", end_y, move_speed).from(start_y)
	tween.tween_property(arrow, "position:y", start_y, move_speed).from(end_y)

func _process(delta: float) -> void:
	if arrow:
		arrow.global_scale = Vector2(0.8, 0.8)

func play_sound() -> void:
	if take_put_sound == null:
		return
	
	if not take_put_sound.playing:
		take_put_sound.play()

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
		
	play_sound()
	HoldItem = item
	HoldItem.get_parent().remove_child(HoldItem)
	ItemAnchor.add_child(HoldItem)
	HoldItem.position = Vector2(0, 0)
	
func TakeItem() -> ItemBase:
	if(HoldItem == null):
		return null
	
	if(!HoldItem.IsPickable()):
		return null;
		
	play_sound()
	var result = HoldItem
	ItemAnchor.remove_child(HoldItem)
	HoldItem = null
	return result
	
func CanPlaceItem(item: ItemBase) -> bool:
	return HoldItem == null
	
func CanTakeItem() -> bool:
	return HoldItem != null
	
func PeekItem() -> ItemBase:
	return HoldItem

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow.visible = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow.visible = false
	
