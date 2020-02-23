extends RigidBody2D
signal dead(ball)
signal points()

func _draw():
    draw_circle(Vector2(0, 0), 12, Color(255, 255, 255))

func _ready():
    randomize()
    yield( get_tree().create_timer(0.5), "timeout" )
    ball_start()

func ball_bounce():
     apply_impulse(Vector2(rand_range(-800,800), rand_range(-800,800)), Vector2(rand_range(-800,800), rand_range(-800,800)))

func ball_start():
     apply_impulse(Vector2(rand_range(-300,-500), rand_range(-300,-500)), Vector2(rand_range(-300,-500), rand_range(-300,-500)))
        
func _process(delta):
    if(linear_velocity.length() > 600):
        linear_velocity.clamped(600)
    if(linear_velocity.length() < 200):
        linear_velocity.clamped(200)
    ball_outside_lower_boundary()
    var bodies=get_colliding_bodies()
    if(bodies.size() > 0):
        for body in bodies:
            if(is_brick(body)):
                remove_brick(body)

func is_brick(body):
    return body.get_name().substr(1,5) == "Brick"
    
func remove_brick(body):
    if is_inside_tree():
        body.queue_free()
    else:
        body.call_deferred("free")
    emit_signal("points")    
    
func ball_outside_lower_boundary():
    if(position.y > 700):
        emit_signal("dead", self)
        self.queue_free()
    