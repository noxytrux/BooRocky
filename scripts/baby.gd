class_name Baby extends ItemBase

@onready var body: AnimatedSprite2D = $Body
@onready var need_timer: Timer = $need_timer
@onready var need_icon: Sprite2D = $need_icon
@onready var progress_bar: ProgressBar = $ProgressBar

const BUBBLE_HUNGRY = preload("res://Assets/emoji_white_bubble/bubble_white_01_17.png")
const BUBBLE_DIRTY = preload("res://Assets/emoji_white_bubble/bubble_white_01_70.png")
const BUBBLE_SAD = preload("res://Assets/emoji_white_bubble/bubble_white_01_68.png")
const BUBBLE_SICK = preload("res://Assets/emoji_white_bubble/bubble_white_01_64.png")
const BUBBLE_HAPPY = preload("res://Assets/emoji_white_bubble/bubble_white_01_82.png")
const BUBBLE_DEAD = preload("res://Assets/emoji_white_bubble/bubble_white_01_77.png")

const COOLDOWN_START = 5.0

var canpickup:bool = true
var dead:bool = false
var disposed:bool = false
var currentScale:float = 1
var animation_speed:float = .5
var finished_dispose:bool = false
var cooldown_need:bool = false
var cooldown:float = 0.0

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

func _ready() -> void:
	need_icon.texture = BUBBLE_HAPPY

func _process(delta: float) -> void:
	
	if progress_bar.visible:
		var progress = (need_timer.time_left / need_timer.wait_time)
		progress_bar.value = progress * 100.0
		progress_bar.modulate = Color((1.0 - progress), progress, 0.0, 1.0)
		
	if cooldown_need:
		cooldown -= delta * animation_speed
		
	if cooldown <= 0 and cooldown_need:
		cooldown_need = false
		cooldown = 0
		DetermineNeed()
	
	if disposed and currentScale > 0:
		currentScale -= delta * animation_speed
		
	if (currentScale <= 0) and not finished_dispose:
		finished_dispose = true
		
	global_scale = Vector2(currentScale, currentScale)
	
func IsPickable() -> bool:
	return canpickup

func PickUp() -> void:
	if dead:
		return
		
	canpickup = false
	body.play("bed")
	
func PutDown() -> void:
	if current_need == BabyNeed.None:
		DetermineNeed()

func Disposed() -> void:
	dead = false
	body.play("die")
	canpickup = false
	disposed = true

func DetermineNeed() -> void:
	current_need = possible_needs.pick_random()
	UpdateNeedIcon()
	need_timer.start()
	progress_bar.visible = true

func UpdateNeedIcon() -> void:
	need_icon.texture = need_to_icon[current_need]
	need_icon.visible = true
		
func Satisfy(item: ItemBase) -> bool:
	var result = satisfaction_dict[current_need]
	if result != item.SelectedType:
		return false
	
	need_timer.stop()
	current_need = BabyNeed.Happy
	UpdateNeedIcon()
	cooldown = COOLDOWN_START
	cooldown_need = true
	progress_bar.visible = false
	item.queue_free()
	return true

func _on_need_timer_timeout() -> void:
	dead = true
	current_need = BabyNeed.Died
	UpdateNeedIcon()
	body.stop()
	progress_bar.visible = false
	canpickup = true	
	
func IsDisposed() -> bool:
	return finished_dispose
	
func CanBabyBeThrowAway() -> bool:
	return dead and canpickup
