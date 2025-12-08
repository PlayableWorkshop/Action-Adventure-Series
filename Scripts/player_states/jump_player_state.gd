class_name JumpPlayerState
extends BasePlayerState


func enter(player: Player) -> void:
	player.velocity.y = player.JUMP_VELOCITY


func pre_update(player: Player) -> void:
	player.change_state_to(PlayerStates.FALL)