class_name exit_node extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Adult:
		body.queue_free()	
