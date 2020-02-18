extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const LASER_VELOCITY: Vector2 = Vector2(0, -400)
var health: int = 10
const DAMAGE: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	removeWhenOffScreen()
	
func move(delta):	
	position += LASER_VELOCITY * delta
	
func removeWhenOffScreen():
	if global_position.y < 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		queue_free()
