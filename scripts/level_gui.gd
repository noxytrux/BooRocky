class_name LevelGUI extends Node2D

var _points := 0

func show_addition_label(delta: int) -> void:
	var addition_label := $Bkg/AdditionLabel
	addition_label.text = "%+d" % delta
	addition_label.visible = true
	var color := Color.FOREST_GREEN if delta > 0 else Color.RED
	addition_label.label_settings.font_color = color
	var transparent_color := color
	transparent_color.a = 0.0
	create_tween().tween_property(addition_label.label_settings, ^":font_color", transparent_color, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
var points: int:
	get:
		return _points
	set(value):
		var delta := value - _points
		if delta != 0:
			_points = value
			$Bkg/Label.text = "%s points" % value
			show_addition_label(delta)
