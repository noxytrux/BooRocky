class_name SummaryPanel extends Control

@onready var child_survived_value: Label = $ChildSurvivedTitle/ChildSurvivedValue
@onready var child_die_value: Label = $ChildDieTitle/ChildDieValue
@onready var satisfy_count_value: Label = $SatisfyCountTitle/SatisfyCountValue
@onready var sum_points_value: Label = $SumPointsTitle/SumPointsValue

func _ready() -> void:
	visible = false

func UpdatePresentation(survived : int, die : int, satisfy : int, sumPoint : int) -> void:
	child_survived_value.text = str(survived)
	child_die_value.text = str(die)
	satisfy_count_value.text = str(satisfy)
	sum_points_value.text = str(sumPoint)

func ShowSummary() -> void:
	visible = true

func _on_exit_button_pressed() -> void:
	SingletonObject.switch_to_menu()
