extends Panel

@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_smile", "emote_3_ear_wave", "emote_4_blink"]
var current_emote: String = ""

func _ready() -> void:
	animated_sprite_2d.play("emote_1_idle")
	current_emote = "emote_1_idle"

	InventoryManager.inventory_changed.connect(on_inventory_changed)
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)

	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func play_emote(animation: String) -> void:
	animated_sprite_2d.play(animation)
	current_emote = animation

func _on_emote_idle_timer_timeout() -> void:
	if current_emote.begins_with("emote_6"):
		return

	var index = randi_range(0, 3)
	var emote = idle_emotes[index]
	play_emote(emote)

func on_inventory_changed() -> void:
	if current_emote == "emote_6_love_kiss":
		return
	play_emote("emote_7_excited")

func on_feed_the_animals() -> void:
	play_emote("emote_6_love_kiss")
	await get_tree().create_timer(2.0).timeout
	play_emote("emote_1_idle")

func _on_animation_finished() -> void:
	if !current_emote.begins_with("emote_1"):
		play_emote("emote_1_idle")
