extends NodeDataResource
class_name SaveToolUnlockResource

@export var unlocked_tools: Array = []

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	unlocked_tools = ToolManager.get_unlocked_tools().duplicate()

func _load_data(window: Node) -> void:
	for tool in unlocked_tools:
		ToolManager.unlock_tool(tool)
