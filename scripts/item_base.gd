class_name ItemBase extends Node2D

enum ITEM_TYPE 
{
	PAMPERS, 
	DIRTY_PAMPERS, #PAMPERS
	FOOD,
	DRUG,
	BABY, #RESERVED
	TOY, 
	INGREDIENT, #FOOD
	PART, #TOY
	SUBSTANCE #DRUG
}

@export var SelectedType = ITEM_TYPE.PAMPERS

func _process(_delta: float) -> void:
	global_scale = Vector2(1.5,1.5)

func IsPickable() -> bool:
	return true 
	
func PickUp() -> void:
	pass
	
func PutDown() -> void:
	pass
	
func IsDisposed() -> bool:
	return true;
	
func Disposed() -> void:
	queue_free()
