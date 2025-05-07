extends Node

var crop_scenes = {
	"corn": preload("res://scenes/objects/plants/corn.tscn"),
	"tomato": preload("res://scenes/objects/plants/tomato.tscn"),
}

func spawn_crop(position: Vector2, crop_type: String) -> Node:
	if crop_scenes.has(crop_type):
		var crop = crop_scenes[crop_type].instantiate()
		crop.global_position = position
		get_tree().current_scene.add_child(crop)
		return crop
	return null
