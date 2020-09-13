extends Camera

var motion := Vector3()
var velocity := Vector3()
var init_rotation := rotation.y
enum CAMERA_STATE {IDLE, ROTATING}
var camera_state = CAMERA_STATE.IDLE
onready var game_world = get_parent().get_node("World")
onready var world_tween = game_world.get_node("Tween")

const GAME_STATE = preload("res://Game.gd").GAME_STATE

func _process(delta: float) -> void:
	var state = get_tree().get_root().get_node("Game").state
	if camera_state == CAMERA_STATE.IDLE:
		match state:
			GAME_STATE.UNIT_MOVE, GAME_STATE.MAP_CONTROL:
				if Input.is_action_pressed("ui_rotate_right"):
					rotate_camera_right()
				if Input.is_action_pressed("ui_rotate_left"):
					rotate_camera_left()
				if Input.is_action_pressed("ui_up"):
					motion.y = 1
				elif Input.is_action_pressed("ui_down"):
					motion.y = -1
				else:
					motion.y = 0
				if Input.is_action_pressed("ui_right"):
					motion.z = 1
				elif Input.is_action_pressed("ui_left"):
					motion.z = -1
				else:
					motion.z = 0
			
				motion.x = 0
				motion = motion.normalized()
				motion = motion \
					.rotated(Vector3(0, 1, 0), rotation.y - init_rotation) \
					.rotated(Vector3(1, 0, 0), cos(rotation.y) * rotation.x) \
					.rotated(Vector3(0, 0, 1), -sin(rotation.y) * rotation.x)
			
				velocity += motion
				velocity *= 0.9
				translation += velocity * delta
				
			GAME_STATE.UNIT_CONTROL:
				pass

func rotate_camera_right():
	camera_state = CAMERA_STATE.ROTATING
	world_tween.interpolate_property(game_world, "rotation", game_world.rotation, game_world.rotation + Vector3(0, PI/2, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	world_tween.start()
	yield(world_tween, "tween_completed")
	camera_state = CAMERA_STATE.IDLE

func rotate_camera_left():
	camera_state = CAMERA_STATE.ROTATING
	world_tween.interpolate_property(game_world, "rotation", game_world.rotation, game_world.rotation - Vector3(0, PI/2, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	world_tween.start()
	yield(world_tween, "tween_completed")
	camera_state = CAMERA_STATE.IDLE

func move_to(target: Vector3, delta: float) -> void:
	var offsetVector := Vector3(-12, 18, 12)
	transform.origin = lerp(transform.origin, Vector3(offsetVector.x + target.x, offsetVector.y + target.y, offsetVector.z + target.z), delta)
