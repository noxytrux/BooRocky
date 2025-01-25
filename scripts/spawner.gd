class_name Spawner extends ContainerItem

@export var scene_to_load : PackedScene

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
	
func TakeItem() -> ItemBase:
	var newItem = scene_to_load.instantiate()
	return newItem

func CanPlaceItem() -> bool:
	return false
