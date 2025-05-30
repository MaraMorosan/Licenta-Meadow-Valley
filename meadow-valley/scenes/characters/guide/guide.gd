extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.give_crop_seeds.connect(on_give_crop_seeds)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/guide.dialogue"), "start")

func on_give_crop_seeds() -> void:
	var unlock_data = get_tree().get_first_node_in_group("tool_unlock_data")
	if unlock_data == null:
		print("⚠️ ToolUnlockDataComponent not found!")
		return

	unlock_data.unlocked_tools.append(DataTypes.Tools.TillGround)
	unlock_data.unlocked_tools.append(DataTypes.Tools.WaterCrops)
	unlock_data.unlocked_tools.append(DataTypes.Tools.PlantCorn)
	unlock_data.unlocked_tools.append(DataTypes.Tools.PlantTomato)

	for tool in unlock_data.unlocked_tools:
		ToolManager.enable_tool_button(tool)
