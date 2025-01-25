class_name Spawner extends ContainerItem

@export var scene_to_load : PackedScene
var createdItem : ItemBase
@onready var spawn_item_timer: Timer = $SpawnItemTimer

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
	
func TakeItem() -> ItemBase:
	if (createdItem == null):
		return null
	else:
		var result = createdItem
		createdItem = null
		spawn_item_timer.start()
		return result

func CanPlaceItem() -> bool:
	return false

func _on_spawn_item_timer_timeout() -> void:
	createdItem = scene_to_load.instantiate()
	print("end time")
