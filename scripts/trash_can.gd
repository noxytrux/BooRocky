class_name TrashCan extends ContainerItem
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return
	
	if not audio_stream_player_2d.playing:
		audio_stream_player_2d.play();
	
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
