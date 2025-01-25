extends ContainerItem

var isCraftingItem : bool
var finishedItem : ItemBase
@export var mapa : Dictionary
@onready var craft_item_timer: Timer = $CraftItemTimer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var craft_sound: AudioStreamPlayer2D = $craft_sound
@onready var interact_sound: AudioStreamPlayer2D = $interact_sound

func _process(delta: float) -> void:
	if progress_bar.visible:
		var progress = (craft_item_timer.time_left / craft_item_timer.wait_time)
		progress_bar.value = progress * 100.0
		progress_bar.modulate = Color((1.0 - progress), progress, 0.0, 1.0)

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return;
		
	play_sfx(interact_sound)
	HoldItem = item
	HoldItem.get_parent().remove_child(HoldItem)
	ItemAnchor.add_child(HoldItem)
	HoldItem.position = Vector2(0, 0)
	craft_item_timer.start()
	isCraftingItem = true;
	progress_bar.visible = true
	
func play_sfx(sound:AudioStreamPlayer2D) -> void:
	if not sound.playing:
		sound.play()
	
func TakeItem() -> ItemBase:
	if(finishedItem == null):
		return null
	
	if(!finishedItem.IsPickable()):
		return null;
		
	play_sfx(interact_sound)
	var result = finishedItem
	ItemAnchor.remove_child(finishedItem)
	finishedItem = null
	return result
	
func FinishCrafting() -> void:
	progress_bar.visible = false
	var ItemToLoad : PackedScene = mapa.get(HoldItem.SelectedType)
	print(ItemToLoad)
	HoldItem.queue_free()
	finishedItem = ItemToLoad.instantiate()
	ItemAnchor.add_child(finishedItem)
	finishedItem.position = Vector2(0, 0)
	isCraftingItem = false;
	play_sfx(craft_sound)
	
func CanPlaceItem(item: ItemBase) -> bool:
	if (!isCraftingItem && HoldItem == null && finishedItem == null):	
		if(mapa.get(item.SelectedType) != null):
			return true;
	return false;
	
func CanTakeItem() -> bool:
	return !isCraftingItem && HoldItem == null && finishedItem != null
	
func PeekItem() -> ItemBase:
	return HoldItem

func _on_craft_item_timer_timeout() -> void:
	FinishCrafting()
