extends NodeDataResource
class_name SceneDataResource

@export var node_name: String
@export var scene_file_path: String
@export var growth_state: int = 0

@export var is_watered: bool = false
@export var starting_day: int = 0

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	node_name       = node.name
	scene_file_path = node.scene_file_path

	if node.has_node("GrowthCycleComponent"):
		var gc = node.get_node("GrowthCycleComponent") as GrowthCycleComponent
		growth_state = int(gc.current_growth_state)
		is_watered   = gc.is_watered
		starting_day   = gc.starting_day

func _load_data(window: Window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D

	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)

	if node_path != null:
		var scene_file_res: Resource = load(scene_file_path)
		scene_node = scene_file_res.instantiate() as Node2D

	if parent_node != null and scene_node != null:
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)

		if scene_node.has_node("GrowthCycleComponent"):
			var gc = scene_node.get_node("GrowthCycleComponent") as GrowthCycleComponent
			gc.set_growth_state(growth_state)
			gc.is_watered = is_watered
			gc.starting_day = starting_day
