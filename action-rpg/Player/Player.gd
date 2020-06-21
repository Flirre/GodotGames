extends KinematicBody2D

const MAX_SPEED = 120
const ACCELERATION = 500
const FRICTION = 500
enum { MOVE, ROLL, ATTACK }

var state = MOVE

var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")


func _ready():
	animation_tree.active = true


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

		ROLL:
			pass

		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", input_vector)
		animation_tree.set("parameters/run/blend_position", input_vector)
		animation_tree.set("parameters/attack/blend_position", input_vector)
		animation_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(_delta):
	velocity = Vector2.ZERO
	animation_state.travel("attack")


func attack_animation_finished():
	state = MOVE
