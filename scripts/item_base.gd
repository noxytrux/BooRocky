class_name ItemBase extends Node2D

enum ITEM_TYPE 
{
	PAMPERS, 
	DIRTY_PAMPERS,
	FOOD,
	DRUG
}

@export var SelectedType = ITEM_TYPE.PAMPERS
