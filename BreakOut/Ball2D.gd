extends RigidBody2D
signal dead(ball)

func _draw():
    draw_circle(Vector2(0, 0), 15, Color(255, 255, 255))

func _ready():
    randomize()
    yield( get_tree().create_timer(0.5), "timeout" )
    ball_bounce()

func ball_bounce():
     apply_impulse(Vector2(rand_range(-800,800), rand_range(-800,800)), Vector2(rand_range(-800,800), rand_range(-800,800)))

func _process(delta):
    ball_outside_lower_boundary()
    print(position)
    
func ball_outside_lower_boundary():
    if(position.y > 700):
        emit_signal("dead", self)
        self.queue_free()
        print('dead')
    