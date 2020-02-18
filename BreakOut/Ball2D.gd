extends RigidBody2D
signal dead(ball)

func _draw():
    draw_circle(Vector2(0, 0), 15, Color(255, 255, 255))
    pass

func _ready():
	randomize()
	apply_impulse(Vector2(rand_range(-300,300), rand_range(-300,300)), Vector2(rand_range(-300,300), rand_range(-100,100)))
	pass

func _process(delta):
	ball_outside_lower_boundary()
	pass
	
func ball_outside_lower_boundary():
	if(self.position.y > 500):
		emit_signal("dead", self)
	