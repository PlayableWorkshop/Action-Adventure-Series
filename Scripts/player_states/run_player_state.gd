class_name RunPlayerState
extends BasePlayerState


func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "run")


func pre_update(player: Player) -> void:
	var current_speed := player.get_current_speed()

	if Input.is_action_just_pressed("ui_accept"):
		player.change_state_to(PlayerStates.JUMP)

	elif not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)

	elif player.move_input.length() == 0:
		player.change_state_to(PlayerStates.IDLE)

	elif current_speed < player.RUN_SPEED:
		player.change_state_to(PlayerStates.WALK)


func update(player: Player, _delta: float) -> void:
	var move := player.move_direction * player.move_input.length()
	player.update_velocity_using_direction(move)
	player.move_and_slide()
	player.turn_to(move)

	var lean := player.move_direction.dot(player.global_basis.x)
	player.last_lean = lerpf(player.last_lean, lean, 0.3)
	player.anim_tree.set("parameters/run_lean/add_amount", player.last_lean)
