class_name CollectableComponent
extends Area2D

@export var collectable_name: String

var can_be_picked: bool = true

func _on_body_entered(body: Node2D) -> void:
	if not can_be_picked:
		return
	await get_tree().create_timer(0.3).timeout
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		print("Collected: ", collectable_name)
		get_parent().queue_free()
