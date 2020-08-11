extends Camera

var motion := Vector3()
var velocity := Vector3()
var init_rotation := rotation.y

onready var state = get_tree().get_root().get_node("Game").state
enum GAME_STATE {MAP_CONTROL, UNIT_CONTROL, UNIT_MOVE}

func _process(delta: float) -> void:
	match state:
		GAME_STATE.UNIT_MOVE:
			continue
		GAME_STATE.MAP_CONTROL:
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

func move_to(target: Vector3, delta: float) -> void:
	var offsetVector := Vector3(-12, 18, 12)
	transform.origin = lerp(transform.origin, Vector3(offsetVector.x + target.x, offsetVector.y + target.y, offsetVector.z + target.z), delta)
