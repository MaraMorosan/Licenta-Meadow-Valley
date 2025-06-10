extends NodeDataResource
class_name SaveDayNightCycleResource

@export var saved_initial_day: int    = 1
@export var saved_initial_hour: int   = 12
@export var saved_initial_minute: int = 30

func _save_data(node: Node) -> void:
	super._save_data(node)
	saved_initial_day    = node.initial_day
	saved_initial_hour   = node.initial_hour
	saved_initial_minute = node.initial_minute

func _load_data(window: Node) -> void:
	var comp = window.get_node_or_null(node_path) as DayNightCycleComponent
	if comp:
		comp.initial_day    = saved_initial_day
		comp.initial_hour   = saved_initial_hour
		comp.initial_minute = saved_initial_minute
		DayAndNightCycleManager.initial_day    = saved_initial_day
		DayAndNightCycleManager.initial_hour   = saved_initial_hour
		DayAndNightCycleManager.initial_minute = saved_initial_minute
		DayAndNightCycleManager.set_initial_time()
