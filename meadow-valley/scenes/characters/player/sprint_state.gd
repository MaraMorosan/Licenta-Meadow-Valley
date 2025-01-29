extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var sprint_speed: int = 100

@warning_ignore("unused_parameter")
func _on_process(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func _on_physics_process(delta: float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()


	if direction == Vector2.UP:
		animated_sprite_2d.play("sprint_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("sprint_front")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("sprint_right")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("sprint_left")
	
	if direction != Vector2.ZERO:
		player.player_direction = direction
		
	player.velocity = direction * sprint_speed
	player.move_and_slide()


func _on_next_transitions() -> void:
	if not GameInputEvents.is_movement_input():
		transition.emit("Idle")
	elif not Input.is_action_pressed("shift"):
		transition.emit("Walk")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
