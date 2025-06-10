extends NodeDataResource
class_name SaveCropDataResource

@export var node_name: String       = ""
@export var scene_file_path: String = ""
@export var growth_state: int       = 0
@export var is_watered: bool        = false
@export var starting_day: int       = 0

func _save_data(node: Node2D) -> void:
	super._save_data(node)

	node_name = node.name

	if node.has_meta("scene_file_path"):
		scene_file_path = str(node.get_meta("scene_file_path"))
	elif node.has_method("get_scene_file_path"):
		scene_file_path = node.get_scene_file_path()
	else:
		scene_file_path = node.get("scene_file_path")

	if node.has_node("GrowthCycleComponent"):
		var gc = node.get_node("GrowthCycleComponent") as GrowthCycleComponent
		growth_state = int(gc.current_growth_state)
		is_watered   = gc.is_watered
		starting_day = gc.starting_day
	else:
		growth_state = 0
		is_watered   = false
		starting_day = 0

func _load_data(window: Window) -> void:
	var parent_node: Node2D = null
	if parent_node_path != null and window != null:
		parent_node = window.get_node_or_null(parent_node_path) as Node2D

	var inst: Node2D = null
	if scene_file_path != "":
		var res = ResourceLoader.load(scene_file_path)
		if res:
			inst = res.instantiate() as Node2D

	if parent_node != null and inst != null:
		inst.name            = node_name
		inst.global_position = global_position
		parent_node.add_child(inst)

		if inst.has_node("GrowthCycleComponent"):
			var gc = inst.get_node("GrowthCycleComponent") as GrowthCycleComponent
			gc.set_growth_state(growth_state)
			gc.is_watered   = is_watered
			gc.starting_day = starting_day
