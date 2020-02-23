extends Node2D
const BALL_SCENE = preload("res://Ball.tscn")
const LIFE = preload("res://Life.tscn")
onready var pointsLabel = get_node("Points")
var points = 0
export (int) var lives
const LIFE_OFFSET = 20

func set_lives(new_lives):
    lives = new_lives
    
func get_lives():
    return lives

func spawn_ball():
    var new_ball = BALL_SCENE.instance()
    add_child(new_ball)
    connect_ball(new_ball)

func handle_balls(ball):
    handle_lives()
    if(get_lives() >= 0):
        spawn_ball()

func handle_lives():
    set_lives(get_lives() - 1)
    if(get_lives() > 0):
        $Lives.get_child(get_lives()).queue_free()
    if(get_lives() == 0):
        $Lives.hide()


func _ready():
    connect_ball($Ball)
    for life in lives:
        var new_life = LIFE.instance()
        $Lives.add_child(new_life)
        
# warning-ignore:unused_argument
func _process(delta: float) -> void:
    if(get_lives() >= 0):
        for life in $Lives.get_children():
            var index = life.get_index()
            var x = index * LIFE_OFFSET
            life.position = Vector2(x, 15)
    else:
        for child in get_children():
            if(child.get_name() == "Paddle"):
                child.hide()
            if(child.get_name() == "Bricks"):
                child.hide()

func connect_ball(ball):
    ball.connect("dead", self, "handle_balls")
    ball.connect("points", self, "update_points")
    
func update_points():
    points = points + 100
    pointsLabel.set_text("Points: " + str(points))

