extends ContainerItem

var isCraftingItem : bool
var finishedItem : ItemBase
@export var mapa : Dictionary
@onready var craft_item_timer: Timer = $CraftItemTimer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var craft_sound: AudioStreamPlayer2D = $craft_sound
@onready var interact_sound: AudioStreamPlayer2D = $interact_sound
@onready var arrow_craft: Sprite2D = $arrow_craft

func _ready() -> void:
	setArrow()

func setArrow() -> void:
	await arrow_craft
	
	if arrow_craft == null:
		return
	
	var move_speed = 0.3
	var start_y := arrow_craft.position.y
	var end_y := arrow_craft.position.y + 10
	var tween := create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow_craft, "position:y", end_y, move_speed).from(start_y)
	tween.tween_property(arrow_craft, "position:y", start_y, move_speed).from(end_y)
	
func _process(delta: float) -> void:
	if arrow_craft:
		arrow_craft.global_scale = Vector2(0.8, 0.8)
	
	if progress_bar.visible:
		var progress = (craft_item_timer.time_left / craft_item_timer.wait_time)
		progress_bar.value = progress * 100.0
		progress_bar.modulate = GlobalValues.progress_to_color(progress)

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


func _on_c_2_body_entered(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow_craft.visible = true


func _on_c_2_body_exited(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow_craft.visible = false
