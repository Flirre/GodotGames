extends Area2D
export (int) var speed
export (int) var damage
export (int) var knockback

var velocity = Vector2()
var direction = Vector2()

func _ready():
    pass

func start(_position, _direction):
    position = _position
    match _direction:
        0:
            direction = Vector2(0, -1)
            self.rotate(deg2rad(90))
        1:
            direction = Vector2(1, 0)
        2:
            direction = Vector2(0, 1)
            self.rotate(deg2rad(90))
        3:
            direction = Vector2(-1, 0)
    velocity = direction * speed
    print(velocity)
    
func _process(delta):
    position += velocity*delta

func disappear():
    queue_free()
