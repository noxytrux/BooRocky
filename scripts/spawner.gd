class_name Spawner extends ContainerItem

@onready var round_manager: RoundManager = %RoundManager
@onready var spawn_item_timer: Timer = $SpawnItemTimer

@export var scene_to_load : PackedScene
@export var spawn_time : float = 0.1
@export var isLimitedByRoundManager : bool = false
var createdItem : ItemBase

func _ready() -> void:
	_on_spawn_item_timer_timeout()
	spawn_item_timer.wait_time = spawn_time

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
	
func TakeItem() -> ItemBase:
	if (createdItem == null):
		return null
	else:
		var result = createdItem
		ItemAnchor.remove_child(createdItem)
		createdItem = null
		spawn_item_timer.start()
		return result
	
func CanPlaceItem(item: ItemBase) -> bool:
	return false
	
func CanTakeItem() -> bool:
	return true
	
func _on_spawn_item_timer_timeout() -> void:
	#If this is not spawner for babies, create object as always. BABIES ARE LIMITED
	if(isLimitedByRoundManager):
		if(round_manager.ChangeLeftBabyCount()):
			createdItem = scene_to_load.instantiate()
			ItemAnchor.add_child(createdItem)
			createdItem.position = Vector2(0, 0)
	else:
		createdItem = scene_to_load.instantiate()
		ItemAnchor.add_child(createdItem)
		createdItem.position = Vector2(0, 0)
