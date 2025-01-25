class_name Spawner extends ContainerItem

@onready var round_manager: RoundManager = %RoundManager
@onready var spawn_item_timer: Timer = $SpawnItemTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var take_sound: AudioStreamPlayer2D = $take_sound

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
		
func play_music() -> void:
	if not audio_stream_player_2d.playing:
		audio_stream_player_2d.play()
		
func play_take_music() -> void:
	if not take_sound.playing:
		take_sound.play()
	
func TakeItem() -> ItemBase:
	if (createdItem == null):
		return null
	else:
		var result = createdItem
		ItemAnchor.remove_child(createdItem)
		createdItem = null
		spawn_item_timer.start()
		play_take_music()
		return result
	
func CanPlaceItem(item: ItemBase) -> bool:
	return false
	
func CanTakeItem() -> bool:
	return true
	
func _on_spawn_item_timer_timeout() -> void:
	#If this is not spawner for babies, create object as always. BABIES ARE LIMITED
	if(isLimitedByRoundManager):
		if(round_manager.ChangeLeftBabyCount()):
			play_music()
			createdItem = scene_to_load.instantiate()
			ItemAnchor.add_child(createdItem)
			createdItem.position = Vector2(0, 0)
	else:
		play_music()
		createdItem = scene_to_load.instantiate()
		ItemAnchor.add_child(createdItem)
		createdItem.position = Vector2(0, 0)
