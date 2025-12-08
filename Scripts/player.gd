class_name Player
extends CharacterBody3D

## Reference to the animation tree node for the player.
@onready var anim_tree: AnimationTree = $AnimationTree

## Tracks the last lean value for adding leaning to our running animation.
var last_lean := 0.0

## Determines how fast the player moves
@export var base_speed := 5.0

## Jump velocity applied when the player jumps.
const JUMP_VELOCITY = 4.5

## Reference to the camera node for adjusting movement direction.
@onready var camera: Node3D = $CameraRig/Camera3D

## Speed that the player is considered "running".
const RUN_SPEED = 3.5

## The current state that our player is in.
var state: BasePlayerState = PlayerStates.IDLE

## The player's movement input for the current physics frame.
var move_input: Vector2 = Vector2.ZERO

## The player's movement input, adjusted for the camera direction.
## This will usually be a normalized vector or zero.
var move_direction: Vector3 = Vector3.ZERO


## Called when the node is added to the scene. We use this to enter the initial state.
func _ready() -> void:
	state.enter(self)


## Changes the current player state and runs the correct functions.
func change_state_to(next_state: BasePlayerState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)


## Called every physics frame. Delegates update logic to the current state.
func _physics_process(delta: float) -> void:
	# Read movement input and store it on the player
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	# Calculate adjusted movement direction based on camera
	move_direction = (camera.global_basis * Vector3(move_input.x, 0, move_input.y))
	move_direction = Vector3(move_direction.x, 0, move_direction.z).normalized()

	# Delegate to current state
	state.pre_update(self)
	state.update(self, delta)


## Rotates the player to face the given direction and smooths the rotation.
func turn_to(direction: Vector3) -> void:
	if direction.length() > 0:
		var yaw := atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, .25)
		rotation.y = yaw


## Returns the player's current speed.
func get_current_speed() -> float:
	return velocity.length()


## Applies velocity based on directional movement input.
func update_velocity_using_direction(direction: Vector3, speed: float = base_speed) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
