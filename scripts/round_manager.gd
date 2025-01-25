class_name RoundManager extends Node

@export var babyCountInRound : int
@export var pointsThresholds = [0.5, 0.7, 1]
var currentPoints : float
var deadBabyCount : int
var survivedBabyCount : int
var babySatisfedNumber : int 
var leftBaby
var pointsMultiplier = 100
var satisfyPointsMultiplier = 25
var IsRoundOn : bool
  
func BabyDied() -> void:
	deadBabyCount += 1
	CheckIfAllBabysAreDeadOrSurvived()
	UpdatePoint()
	
func BabySurvive() -> void:
	survivedBabyCount += 1
	CheckIfAllBabysAreDeadOrSurvived()
	UpdatePoint()
	
func BabySatisfy() -> void:
	babySatisfedNumber += 1
	UpdatePoint()

func CheckIfAllBabysAreDeadOrSurvived() -> void:
	if(deadBabyCount + survivedBabyCount == babyCountInRound):
		FinishRound();
		
func UpdatePoint() -> void:
	currentPoints = survivedBabyCount - deadBabyCount
	currentPoints *= 100
	
	currentPoints += babySatisfedNumber * satisfyPointsMultiplier
	
	%LevelGUI.points = currentPoints
	
func GetStars() -> int:
	var MaxPoints = babyCountInRound * 100
	var result = 0
	
	for index in pointsThresholds.size():
		if(pointsThresholds[index] * MaxPoints <= currentPoints):
			result+=1
	
	return result

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leftBaby = babyCountInRound
	IsRoundOn = true;
	
func ChangeLeftBabyCount() -> bool:
	if(leftBaby > 0):
		leftBaby -= 1
		return true
	return false

func FinishRound() -> void:
	print("END")
