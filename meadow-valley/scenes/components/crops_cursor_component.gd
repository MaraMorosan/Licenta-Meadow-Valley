class_name CropsCursorComponent
extends Node2D

@export var tilled_soil_tilemap_layer: TileMapLayer

var corn_plant_scene   = preload("res://scenes/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

var player: Player
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()

	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool in [DataTypes.Tools.PlantCorn, DataTypes.Tools.PlantTomato]:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	mouse_position       = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position        = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id       = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position  = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance             = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	if distance >= 20.0:
		return

	if cell_source_id < 0:
		return

	var inst: Node2D
	if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
		inst = corn_plant_scene.instantiate() as Node2D
	else:
		inst = tomato_plant_scene.instantiate() as Node2D

	inst.global_position = local_cell_position
	get_parent().find_child("CropFields").add_child(inst)

func remove_crop() -> void:
	if distance < 20.0:
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		for node in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
