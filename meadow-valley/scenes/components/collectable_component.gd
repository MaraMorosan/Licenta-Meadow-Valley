class_name CollectableComponent
extends Area2D

@export var collectable_name: String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Collected")
		await get_tree().create_timer(0.3).timeout
		get_parent().queue_free()
