extends KinematicBody2D
export (int) var speed
var game_screen_size
var player_width
var player_height
var player_direction
enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}
var velocity: Vector2
var shooting: bool
export (PackedScene) var Laser 
onready var shootTimer = get_node("ShootTimer")
onready var animatedSprite = get_node("AnimatedSprite")
signal shoot

func _ready():
    game_screen_size = get_viewport_rect().size
    player_width = $CollisionShape2D.shape.radius
    player_height = $CollisionShape2D.shape.height
    shooting = false
    set_process(true)
    pass
    
func _physics_process(delta):
    velocity = move_and_slide(velocity)
    if shootTimer.time_left == 0:
        shooting = false
    check_boundaries()

func get_input():
    velocity = Vector2(0,0)
    if(Input.is_action_pressed("move_left")):
        velocity.x = -speed
        player_direction = DIRECTIONS.LEFT
        animatedSprite.set_flip_h(true)
    if(Input.is_action_pressed("move_right")):
        velocity.x = speed
        player_direction = DIRECTIONS.RIGHT
        animatedSprite.set_flip_h(false)
    if(Input.is_action_pressed("move_up")):
        velocity.y = -speed
        player_direction = DIRECTIONS.UP
    if(Input.is_action_pressed("move_down")):
        velocity.y = speed        
        player_direction = DIRECTIONS.DOWN
    if(Input.is_action_pressed("shoot")):
        shoot()

  #Quit on Q press      
    if(Input.is_key_pressed(KEY_Q)):
        get_tree().quit()
    
func check_boundaries():
    self.position.x = clamp(self.position.x, 0 + player_width, game_screen_size.x-player_width)
    self.position.y = clamp(self.position.y, 0 + player_height, game_screen_size.y-player_height)


func shoot():
    if shootTimer.time_left == 0:
        emit_signal("shoot", Laser, global_position, player_direction)
        shooting = true
        shootTimer.start()
