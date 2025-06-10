extends NodeDataResource
class_name SavePlayerPositionResource

func _save_data(node: Node2D) -> void:
	super._save_data(node)

func _load_data(window: Node) -> void:
	if node_path == null or window == null:
		return
	var player = window.get_node_or_null(node_path) as Node2D
	if player:
		player.global_position = global_position
