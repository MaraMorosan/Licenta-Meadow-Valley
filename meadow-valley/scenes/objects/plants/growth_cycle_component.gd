class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool = false
var starting_day: int = 0
var current_day: int = 0

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	current_day = day
	if not is_watered:
		return

	if starting_day == 0:
		starting_day = day

	var days_since = current_day - starting_day

	_advance_growth(days_since)
	_advance_harvest(days_since)

func _advance_growth(days_since: int) -> void:
	if current_growth_state >= DataTypes.GrowthStates.Maturity:
		return

	var new_state = int(current_growth_state) + days_since
	new_state = min(new_state, DataTypes.GrowthStates.Maturity)
	if new_state != int(current_growth_state):
		current_growth_state = new_state
		if current_growth_state == DataTypes.GrowthStates.Maturity:
			emit_signal("crop_maturity")

func _advance_harvest(days_since: int) -> void:
	if current_growth_state != DataTypes.GrowthStates.Maturity:
		return

	if days_since >= days_until_harvest - 2:
		current_growth_state = DataTypes.GrowthStates.Harvesting
		emit_signal("crop_harvesting")

func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state

func set_growth_state(new_state: int) -> void:
	current_growth_state = new_state
