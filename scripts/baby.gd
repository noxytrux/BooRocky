class_name Baby extends ItemBase

@onready var body: AnimatedSprite2D = $Body

bool canpickup = true

]func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func IsPickable() -> bool:
	return canpickup
