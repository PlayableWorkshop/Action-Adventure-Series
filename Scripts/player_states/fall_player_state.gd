class_name FallPlayerState
extends BasePlayerState


func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "fall")


func pre_update(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)


func update(player: Player, delta: float) -> void:
	var move := player.move_direction * player.move_input.length()

	player.velocity += player.get_gravity() * delta
	player.update_velocity_using_direction(move, player.base_speed * 0.25)
	player.move_and_slide()
	player.turn_to(move)