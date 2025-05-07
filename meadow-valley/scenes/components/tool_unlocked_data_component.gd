class_name ToolUnlockDataComponent
extends SaveDataComponent

var unlocked_tools: Array[DataTypes.Tools] = []

func _ready() -> void:
	add_to_group("tool_unlock_data")
	add_to_group("save_data_component")

func _save_data() -> NodeDataResource:
	var resource := NodeDataResource.new()
	resource.data["unlocked_tools"] = unlocked_tools
	return resource

func _load_data(_root: Node) -> void:
	if self.data.has("unlocked_tools"):
		unlocked_tools = self.data["unlocked_tools"]
		for tool in unlocked_tools:
			ToolManager.enable_tool_button(tool)
