extends CharacterBody3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
var last_lean := 0.0

## Determines how fast the player moves
@export var speed := 5.0
const JUMP_VELOCITY = 4.5 # constants never change
@onready var camera: Node3D = $CameraRig/Camera3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	turn_to(direction)

	var current_speed := velocity.length()
	const RUN_SPEED := 3.5
	const BLEND_SPEED := 0.2

	if not is_on_floor():
		anim_tree.set("parameters/movement/transition_request", "fall")

	elif current_speed > RUN_SPEED:
		anim_tree.set("parameters/movement/transition_request", "run")
		var lean := direction.dot(global_basis.x)
		last_lean = lerpf(last_lean, lean, 0.3)
		anim_tree.set("parameters/run_lean/add_amount", last_lean)
	elif current_speed > 0.0:
		anim_tree.set("parameters/movement/transition_request", "walk")
		var walk_speed := lerpf(0.5, 1.75, current_speed / RUN_SPEED)
		anim_tree.set("parameters/walk_speed/scale", walk_speed)
	else:
		anim_tree.set("parameters/movement/transition_request", "idle")

func turn_to(direction: Vector3) -> void:
	if direction.length() > 0:
		var yaw := atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, .25)
		rotation.y = yaw
