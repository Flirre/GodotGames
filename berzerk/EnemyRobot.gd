extends KinematicBody2D

var direction
var shot_direction
var shot
var space_state
enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}
onready var entity = get_node("entity")
onready var player = get_parent().get_node("Player")
onready var ray = get_node("RayCast2D")

export (PackedScene) var Laser
signal shoot

func _ready() -> void:
	direction = DIRECTIONS.DOWN
	shot_direction = Vector2(0,-1)
	entity.shooting = false
	entity.shootTimer.connect("timeout", self, "shoot")

func _physics_process(delta):
	if(ray.enabled):
		ray.set_cast_to(player.position - self.position)
		if(not ray.is_colliding()):
			entity.shooting = true
		else:
			entity.shooting = false

func shoot():
	if entity.shooting and entity.shootTimer.time_left == 0:
		calculateDirection()
		emit_signal("shoot", Laser, global_position, direction)
	entity.shootTimer.start()

func calculateDirection():
	shot = (self.position - player.position).normalized()
	if shot.x > shot.y:
		shot.x = 0
	else: shot.y = 0
	shot = shot.round()
	match shot:
		Vector2(0,1):
			direction = 0
		Vector2(-1,0):
			direction = 1
		Vector2(0,-1):
			direction = 2
		Vector2(1,0):
			direction = 3


func _on_FOV_body_entered(body):
	ray.enabled = true

func _on_FOV_body_exited(body):
	ray.enabled = false
	entity.shooting = false
