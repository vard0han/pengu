class_name CardPickup
extends Area2D

func _on_body_entered(body: Node) -> void:
	if body is Player:
		print("card")
		queue_free()
