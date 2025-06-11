extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

const SELL_SCENES = {
	"corn": preload("res://scenes/objects/plants/corn_harvest.tscn"),
	"tomato": preload("res://scenes/objects/plants/tomato_harvest.tscn"),
	"milk": preload("res://scenes/objects/milk.tscn"),
	"egg": preload("res://scenes/objects/egg.tscn"),
	"log": preload("res://scenes/objects/trees/log.tscn"),
	"stone": preload("res://scenes/objects/rocks/stone.tscn")
}

var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	GameDialogueManager.sell_items.connect(on_sell_items)

func on_interactable_activated() -> void:
	in_range = true
	interactable_label_component.show()

func on_interactable_deactivated() -> void:
	in_range = false
	interactable_label_component.hide()

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("show_dialogue"):
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().root.add_child(balloon)
		balloon.start(
			load("res://dialogue/conversations/shopkeeper.dialogue"),
			"start"
		)

func on_sell_items() -> void:
	if not in_range:
		return

	var inv_copy = InventoryManager.inventory.duplicate()

	for item_name in inv_copy.keys():
		var count = inv_copy[item_name]
		if count == null or count <= 0:
			continue
		if SELL_SCENES.has(item_name):
			var scene: PackedScene = SELL_SCENES[item_name]
			var drop_height = 60
			var spawn_spread = 20
			var sell_speed = 0.4
			var delay_between = 0.05

			for i in range(count):
				var inst = scene.instantiate() as Node2D
				var start_pos = global_position + Vector2(
					randf_range(-spawn_spread, spawn_spread),
					-drop_height
				)
				inst.global_position = start_pos
				if inst.has_node("CollectableComponent"):
					inst.get_node("CollectableComponent").set_physics_process(false)
				get_tree().root.add_child(inst)

				await get_tree().create_timer(delay_between * i).timeout

				var tween = get_tree().create_tween()
				tween.tween_property(inst, "global_position", global_position, sell_speed)
				tween.tween_callback(func ():
					CurrencyManager.add_coins(1)
				)
				tween.tween_callback(inst.queue_free)

			InventoryManager.inventory[item_name] = 0

	InventoryManager.inventory_changed.emit()
