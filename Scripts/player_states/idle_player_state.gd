class_name IdlePlayerState
extends BasePlayerState


func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "idle")


func pre_update(player: Player) -> void:
	if not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)

	elif player.move_input.length() > 0.0:
		player.change_state_to(PlayerStates.WALK)

	elif Input.is_action_just_pressed("ui_accept"):
		player.change_state_to(PlayerStates.JUMP)


func update(player: Player, _delta: float) -> void:
	player.velocity = player.velocity.move_toward(Vector3.ZERO, player.base_speed)
	player.move_and_slide()