extends KinematicBody2D

var game_screen_size
var player_width
var player_height
var player_direction

onready var entity = get_node("entity")

enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}
var velocity: Vector2

export (PackedScene) var Laser 

signal shoot

func _ready():
    game_screen_size = get_viewport_rect().size
    player_width = $CollisionShape2D.shape.radius
    player_height = $CollisionShape2D.shape.height
    entity.shooting = false
    set_process(true)
    
func _physics_process(delta):
    velocity = move_and_slide(velocity)
    check_boundaries()

func get_input():
    velocity = Vector2(0,0)
    if(Input.is_action_pressed("move_left")):
        velocity.x = -entity.speed
        player_direction = DIRECTIONS.LEFT
        entity.animatedSprite.set_flip_h(true)
    if(Input.is_action_pressed("move_right")):
        velocity.x = entity.speed
        player_direction = DIRECTIONS.RIGHT
        entity.animatedSprite.set_flip_h(false)
    if(Input.is_action_pressed("move_up")):
        velocity.y = -entity.speed
        player_direction = DIRECTIONS.UP
    if(Input.is_action_pressed("move_down")):
        velocity.y = entity.speed        
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
    if entity.shootTimer.time_left == 0:
        emit_signal("shoot", Laser, global_position, player_direction)
        entity.shooting = true
        entity.shootTimer.start()
