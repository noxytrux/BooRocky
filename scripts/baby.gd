class_name Baby extends ItemBase

@onready var body: AnimatedSprite2D = $Body
@onready var need_timer: Timer = $need_timer

var canpickup:bool = true
var dead:bool = false
var disposed:bool = false
var currentScale:float = 1
var animation_speed:float = .5
var finished_dispose:bool = false

func _ready() -> void:
	need_timer.start()

func _process(delta: float) -> void:
	if disposed and currentScale > 0:
		currentScale -= delta * animation_speed
		
	if (currentScale <= 0) and not finished_dispose:
		finished_dispose = true
		
	global_scale = Vector2(currentScale, currentScale)
	
	if dead && !canpickup:
		body.stop()
		canpickup = true	
	
	
func IsPickable() -> bool:
	return canpickup

func PickUp() -> void:
	if dead:
		return
		
	canpickup = false
	body.play("bed")
	
	
func PutDown() -> void:
	if dead and canpickup:
		dead = false
		body.play("die")
		canpickup = false
		disposed = true

func _on_need_timer_timeout() -> void:
	dead = true
	
func IsDisposed() -> bool:
	return finished_dispose
