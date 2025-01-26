class_name TrashCan extends ContainerItem
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var arrow_trash: Sprite2D = $arrow_trash

func _ready() -> void:
	setArrow()

func setArrow() -> void:
	await arrow_trash
	
	if arrow_trash == null:
		return
	
	var move_speed = 0.3
	var start_y := arrow_trash.position.y
	var end_y := arrow_trash.position.y + 10
	var tween := create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(arrow_trash, "position:y", end_y, move_speed).from(start_y)
	tween.tween_property(arrow_trash, "position:y", start_y, move_speed).from(end_y)
	
func _process(delta: float) -> void:
	if arrow_trash:
		arrow_trash.global_scale = Vector2(0.8, 0.8)
		
func PlaceItem(item: ItemBase) -> void:
	if(item == null):
		return
	
	if not audio_stream_player_2d.playing:
		audio_stream_player_2d.play()
	
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


func _on_a_2_body_entered(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow_trash.visible = true


func _on_a_2_body_exited(body: Node2D) -> void:
	if body is ContainerItem or body is TileMapLayer:
		return
		
	arrow_trash.visible = false
