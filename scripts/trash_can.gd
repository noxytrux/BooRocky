class_name TrashCan extends ContainerItem

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return
	
	item
	item.get_parent().remove_child(item)
	ItemAnchor.add_child(item)
	item.position = Vector2(0, 0)
	item.Disposed()
	
func TakeItem() -> ItemBase:
	return null

func CanPlaceItem(item: ItemBase) -> bool:
	if(item is Baby):
		if(!item.CanBabyBeThrowAway()):
			return	false
	
	return true
	
func CanTakeItem() -> bool:
	return false
