class_name ContainerItem extends Node2D

@export var HoldItem: ItemBase
@onready var ItemAnchor = $ItemAnchor
@onready var take_put_sound: AudioStreamPlayer2D = $take_put_sound

func _ready() -> void:
	PlaceItem(HoldItem) #ONLY FOR TEST - DELETE THIS LATER

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
