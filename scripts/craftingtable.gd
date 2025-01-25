extends ContainerItem

var isCraftingItem : bool
var finishedItem : ItemBase
@export var mapa : Dictionary
@onready var craft_item_timer: Timer = $CraftItemTimer

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
		
	HoldItem = item
	HoldItem.get_parent().remove_child(HoldItem)
	ItemAnchor.add_child(HoldItem)
	HoldItem.position = Vector2(0, 0)
	craft_item_timer.start()
	isCraftingItem = true;
	
func TakeItem() -> ItemBase:
	if(finishedItem == null):
		return null
	
	if(!finishedItem.IsPickable()):
		return null;
		
	var result = finishedItem
	ItemAnchor.remove_child(finishedItem)
	finishedItem = null
	return result
	
func FinishCrafting() -> void:
	var ItemToLoad : PackedScene = mapa.get(HoldItem.SelectedType)
	print(ItemToLoad)
	HoldItem.queue_free()
	finishedItem = ItemToLoad.instantiate()
	ItemAnchor.add_child(finishedItem)
	finishedItem.position = Vector2(0, 0)
	isCraftingItem = false;
	
func CanPlaceItem(item: ItemBase) -> bool:
	return !isCraftingItem && HoldItem == null && finishedItem == null
	
func CanTakeItem() -> bool:
	return !isCraftingItem && HoldItem == null && finishedItem != null
	
func PeekItem() -> ItemBase:
	return HoldItem

func _on_craft_item_timer_timeout() -> void:
	FinishCrafting()
