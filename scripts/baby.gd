class_name Baby extends ItemBase

@onready var body: AnimatedSprite2D = $Body
@onready var need_timer: Timer = $need_timer
@onready var need_icon: Sprite2D = $need_icon
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var progress_bar_need_bed: ProgressBar = $ProgressBarNeedBed
@onready var round_manager: RoundManager = null
@onready var satisfy_sound: AudioStreamPlayer2D = $satisfy_sound
@onready var nope_sound: AudioStreamPlayer2D = $nope_sound
@onready var need_sound: AudioStreamPlayer2D = $need_sound
@onready var died_sound: AudioStreamPlayer2D = $died_sound
@onready var find_bed_timer: Timer = $find_bed_timer
@onready var need_bed_icon: Sprite2D = $need_bed_icon

const DIAPER = preload("res://scenes/Items/DirtyPampers.tscn")
const ADULT  = preload("res://scenes/adult.tscn")

const BUBBLE_HUNGRY = preload("res://Assets/emoji_white_bubble/bubble_white_01_17.png")
const BUBBLE_DIRTY = preload("res://Assets/emoji_white_bubble/bubble_white_01_70.png")
const BUBBLE_SAD = preload("res://Assets/emoji_white_bubble/bubble_white_01_68.png")
const BUBBLE_SICK = preload("res://Assets/emoji_white_bubble/bubble_white_01_64.png")
const BUBBLE_HAPPY = preload("res://Assets/emoji_white_bubble/bubble_white_01_82.png")
const BUBBLE_DEAD = preload("res://Assets/emoji_white_bubble/bubble_white_01_77.png")

const COOLDOWN_START = 5.0
const MAX_SATISFACTION = 3

var canpickup:bool = true
var dead:bool = false
var disposed:bool = false
var currentScale:float = 1
var animation_speed:float = .5
var finished_dispose:bool = false
var cooldown_need:bool = false
var cooldown:float = 0.0
var diaper:ItemBase = null
var satisiaction:int = 0;

enum BabyNeed 
{
	None,
	Hungry,
	Dirty,
	Sad,
	Sick,
	Happy,
	Died
}

var current_need:BabyNeed = BabyNeed.None
var possible_needs = [BabyNeed.Hungry, BabyNeed.Dirty, BabyNeed.Sad, BabyNeed.Sick]

var need_to_icon = {
	BabyNeed.Hungry : BUBBLE_HUNGRY,
	BabyNeed.Dirty : BUBBLE_DIRTY,
	BabyNeed.Sad : BUBBLE_SAD,
	BabyNeed.Sick : BUBBLE_SICK,
	BabyNeed.Happy : BUBBLE_HAPPY,
	BabyNeed.Died : BUBBLE_DEAD
}

var satisfaction_dict = {
	BabyNeed.Hungry : ItemBase.ITEM_TYPE.FOOD,
	BabyNeed.Dirty : ItemBase.ITEM_TYPE.PAMPERS,
	BabyNeed.Sad : ItemBase.ITEM_TYPE.TOY,
	BabyNeed.Sick : ItemBase.ITEM_TYPE.DRUG
}

func play_audio(sound:AudioStreamPlayer2D) -> void:
		if not sound.playing:
			sound.play()

func _ready() -> void:
	need_icon.texture = BUBBLE_HAPPY
	round_manager = get_tree().get_current_scene().get_child(0)
	SetFindBedNeed(true);

func _process(delta: float) -> void:
	
	if progress_bar.visible:
		var progress = (need_timer.time_left / need_timer.wait_time)
		progress_bar.value = progress * 100.0
		progress_bar.modulate = GlobalValues.progress_to_color(progress)
		
	if progress_bar_need_bed.visible:
		var progress = (find_bed_timer.time_left / find_bed_timer.wait_time)
		progress_bar_need_bed.value = progress * 100.0
		progress_bar_need_bed.modulate = GlobalValues.progress_to_color(progress)
		
	if cooldown_need:
		cooldown -= delta * animation_speed
		
	if cooldown <= 0 and cooldown_need:
		cooldown_need = false
		cooldown = 0
		if grownup():
			DetermineNeed()
	
	if disposed and currentScale > 0:
		currentScale -= delta * animation_speed
		
	if (currentScale <= 0) and not finished_dispose:
		finished_dispose = true
		
	global_scale = Vector2(currentScale, currentScale)
	
func grownup() -> bool:
	if satisiaction == MAX_SATISFACTION:		
		var root_node = get_tree().get_current_scene()
		var exits = root_node.find_children("*", "exit_node") as Array[exit_node]

		if not exits.is_empty():
			round_manager.BabySurvive()
			var adult = ADULT.instantiate()
			var exit = exits.pick_random()
			exit.get_parent().get_parent().add_child(adult)

			adult.destination = exit
			adult.position = global_position + Vector2(64.0, 96.0)
			adult.makepath()
			
			play_audio(satisfy_sound)
			
			queue_free()
			
			return false
		else:
			return true
	else:
		return true
	
func IsPickable() -> bool:
	return canpickup

func PickUp() -> void:
	if dead:
		return
		
	canpickup = false
	body.play("bed")
	
func PutDown() -> void:
	SetFindBedNeed(false);
	await get_tree().create_timer(1).timeout
	
	if current_need == BabyNeed.None && !dead:
		DetermineNeed()

func Disposed() -> void:
	dead = false
	body.play("die")
	need_icon.visible = false
	canpickup = false
	disposed = true

func DetermineNeed() -> void:
	current_need = possible_needs.pick_random()
	UpdateNeedIcon()
	need_timer.start()
	progress_bar.visible = true
	
	play_audio(need_sound)
	
	if current_need == BabyNeed.Dirty:
		diaper = DIAPER.instantiate()
		add_child(diaper)
		diaper.position = position

func UpdateNeedIcon() -> void:
	need_icon.texture = need_to_icon[current_need]
	need_icon.visible = true
		
func Satisfy(item: ItemBase) -> bool:
	
	if current_need == BabyNeed.Died or current_need == BabyNeed.Happy:
		play_audio(nope_sound)
		return false
	
	var result = satisfaction_dict[current_need]
	if result != item.SelectedType:
		play_audio(nope_sound)
		return false
	
	need_timer.stop()
	current_need = BabyNeed.Happy
	UpdateNeedIcon()
	cooldown = COOLDOWN_START
	cooldown_need = true
	progress_bar.visible = false
	item.queue_free()
	satisiaction += 1
	round_manager.BabySatisfy()
	
	play_audio(satisfy_sound)
	
	return true

func _on_need_timer_timeout() -> void:
	round_manager.BabyDied()
	dead = true
	current_need = BabyNeed.Died
	UpdateNeedIcon()
	body.stop()
	progress_bar.visible = false
	canpickup = true	
	play_audio(died_sound)
	
	if HasDiaper():
		diaper.queue_free()
	
func _on_find_bed_timer_timeout() -> void:
	round_manager.BabyDied()
	dead = true
	canpickup = true
	current_need = BabyNeed.Died
	UpdateNeedIcon()
	SetFindBedNeed(false)
	body.stop()
	play_audio(died_sound)
	
func IsDisposed() -> bool:
	return finished_dispose
	
func CanBabyBeThrowAway() -> bool:
	return dead and canpickup
	
func HasDiaper() -> bool:
	return diaper != null
	
func GetDiaper() -> ItemBase:
	remove_child(diaper)
	return diaper

func SetFindBedNeed(state : bool) -> void:
	if(state):
		find_bed_timer.start()
	else:
		find_bed_timer.stop()
	
	need_bed_icon.visible = state
	progress_bar_need_bed.visible = state
