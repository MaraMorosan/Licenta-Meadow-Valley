extends Node

var unlocked_tools: Array[DataTypes.Tools] = []
var selected_tool:    DataTypes.Tools     = DataTypes.Tools.None

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool

func unlock_tool(tool: DataTypes.Tools) -> void:
	if not unlocked_tools.has(tool):
		unlocked_tools.append(tool)
		emit_signal("enable_tool", tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	emit_signal("enable_tool", tool)

func get_unlocked_tools() -> Array:
	return unlocked_tools
