class_name LevelGUI extends Node2D

var _points := 0

var points: int:
	get:
		return _points
	set(value):
		_points = value
		$Bkg/Label.text = "%s points" % value
