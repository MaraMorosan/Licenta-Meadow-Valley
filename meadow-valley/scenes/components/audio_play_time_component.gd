extends Timer
class_name AudioPlayTimeComponent

@export var audio_stream_player_2D: AudioStreamPlayer2D

@export_range(0.0, 2000.0, 1.0) var max_hear_distance: float = 400.0
@export_range(-80.0,   0.0,   1.0) var min_volume_db: float = -40.0
@export_range(-80.0,   0.0,   1.0) var max_volume_db: float =   0.0

var _player: Node2D

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

func _on_timeout() -> void:
	if _player == null:
		return
	var dist = audio_stream_player_2D.global_position.distance_to(_player.global_position)
	if dist > max_hear_distance:
		return
	var t = clamp(dist / max_hear_distance, 0.0, 1.0)
	audio_stream_player_2D.volume_db = lerp(max_volume_db, min_volume_db, t)
	audio_stream_player_2D.play()
