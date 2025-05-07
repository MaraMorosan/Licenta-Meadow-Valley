class_name VegetableSaveDataComponent
extends SaveDataComponent

@export var crop_type: String

@onready var growth_cycle_component = get_parent().get_node("GrowthCycleComponent")

func _ready() -> void:
	add_to_group("save_data_component")

func _save_data() -> NodeDataResource:
	var resource := NodeDataResource.new()
	resource.data["position"] = get_parent().global_position
	resource.data["growth_state"] = growth_cycle_component.get_current_growth_state()
	resource.data["is_watered"] = growth_cycle_component.is_watered
	resource.data["crop_type"] = crop_type
	return resource

func _load_data(_root: Node) -> void:
	if self.data.is_empty():
		return

	var parent = get_parent()
	parent.global_position = self.data["position"]
	growth_cycle_component.set_growth_state(self.data["growth_state"])
	growth_cycle_component.is_watered = self.data["is_watered"]
