class_name SaveLevelDataComponent
extends Node

const SaveToolUnlockResource = preload("res://resources/save_tool_unlock_resource.gd")

var level_scene_name: String
var save_game_data_path: String = "user://saves/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")

	game_data_resource = SaveGameDataResource.new()

	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)

func save_game() -> void:
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)

	var level_save_file_name: String = save_file_name % level_scene_name
	save_node_data()
	
	game_data_resource.inventory_data = InventoryManager.inventory.duplicate()
	
	game_data_resource.saved_day    = DayAndNightCycleManager.current_day
	game_data_resource.saved_hour   = DayAndNightCycleManager.current_hour
	game_data_resource.saved_minute = DayAndNightCycleManager.current_minute
	
	game_data_resource.saved_coins = CurrencyManager.coins
	
	var tool_res = SaveToolUnlockResource.new()
	tool_res.unlocked_tools = ToolManager.get_unlocked_tools().duplicate()
	game_data_resource.save_data_nodes.append(tool_res)
	
	var full_path: String = save_game_data_path + level_save_file_name
	
	var result: int = ResourceSaver.save(game_data_resource, full_path)
	print("Save result:", result)

func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name

	if !FileAccess.file_exists(save_game_path):
		return

	game_data_resource = ResourceLoader.load(save_game_path)
	if game_data_resource == null:
		return

	DayAndNightCycleManager.set_time(
		game_data_resource.saved_day,
		game_data_resource.saved_hour,
		game_data_resource.saved_minute
)
	
	DayAndNightCycleManager.time_tick.emit(
		game_data_resource.saved_day,
		game_data_resource.saved_hour,
		game_data_resource.saved_minute
)
	
	InventoryManager.inventory = game_data_resource.inventory_data.duplicate()
	InventoryManager.inventory_changed.emit()
	
	CurrencyManager.coins = game_data_resource.saved_coins
	CurrencyManager.emit_signal("coins_changed", CurrencyManager.coins)
	
	var root_node: Window = get_tree().root
	
	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
