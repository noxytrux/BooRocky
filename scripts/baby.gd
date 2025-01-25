class_name Baby extends ItemBase

@onready var body: AnimatedSprite2D = $Body
@onready var need_timer: Timer = $need_timer

var canpickup:bool = true
var dead:bool = false

func _ready() -> void:
	need_timer.start()

func _process(delta: float) -> void:
	
	global_scale = Vector2(1,1)
	
	if dead && !canpickup:
		body.stop()
		canpickup = true	
	
	
func IsPickable() -> bool:
	return canpickup

func PickUp() -> void:
	
	if !dead:
		canpickup = false
	
	body.play("bed")
	
func PutDown() -> void:
	
	if dead and canpickup:
		dead = false
		body.play("die")
		canpickup = false

func _on_need_timer_timeout() -> void:
	dead = true
