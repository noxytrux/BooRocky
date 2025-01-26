class_name SummaryPanel extends Control

@onready var child_survived_value: Label = $ChildSurvivedTitle/ChildSurvivedValue
@onready var child_die_value: Label = $ChildDieTitle/ChildDieValue
@onready var satisfy_count_value: Label = $SatisfyCountTitle/SatisfyCountValue
@onready var sum_points_value: Label = $SumPointsTitle/SumPointsValue


@onready var star_4: TextureRect = $"Star#1/Star#4"
@onready var star_5: TextureRect = $"Star#2/Star#5"
@onready var star_6: TextureRect = $"Star#3/Star#6"

@export var starCollection : Array = []

func _ready() -> void:
	visible = false
	starCollection.append(star_4)
	starCollection.append(star_5)
	starCollection.append(star_6)

func UpdatePresentation(survived : int, die : int, satisfy : int, sumPoint : int, startAmount : int) -> void:
	child_survived_value.text = str(survived)
	child_die_value.text = str(die)
	satisfy_count_value.text = str(satisfy)
	sum_points_value.text = str(sumPoint)
	UpdateStars(startAmount)

func UpdateStars(amount : int) -> void:
	for index in range(0, amount):
		starCollection[index].visible=true
		

func ShowSummary() -> void:
	visible = true

func _on_exit_button_pressed() -> void:
	SingletonObject.switch_to_menu()
