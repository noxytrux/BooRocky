class_name ContainerItem extends Node2D

@export var HoldItem: ItemBase
@onready var ItemAnchor = $ItemAnchor

func _ready() -> void:
	PlaceItem(HoldItem) #ONLY FOR TEST - DELETE THIS LATER

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
		
	HoldItem = item
	HoldItem.get_parent().remove_child(HoldItem)
	ItemAnchor.add_child(HoldItem)
	HoldItem.position = Vector2(0, 0)
	
func TakeItem() -> ItemBase:
	if(HoldItem == null):
		return null
	
	if(!HoldItem.IsPickable()):
		return null;
		
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
