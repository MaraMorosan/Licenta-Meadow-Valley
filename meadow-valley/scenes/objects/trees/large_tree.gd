extends AnimatedSprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var fall_tree_offset = Vector2(8, 0)
var is_falling = false
var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	

func on_hurt(hit_damage: int) -> void:
	play("hit_tree")
	damage_component.apply_damage(hit_damage)

func on_max_damage_reached() -> void:
	await get_tree().create_timer(0.3).timeout
	
	collision_shape_2d.disabled = true
	
	position -= fall_tree_offset
	play("fall_tree")

func _on_animation_finished() -> void:
	if animation == "fall_tree":
		call_deferred("add_log_scene")
		queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	var spawn_offset = Vector2(-5, -5)
	log_instance.global_position = global_position + spawn_offset
	get_parent().add_child(log_instance)
