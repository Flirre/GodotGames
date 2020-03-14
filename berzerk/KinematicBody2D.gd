extends KinematicBody2D
export (int) var speed
var game_screen_size
var player_width
var player_height
var velocity: Vector2

func _ready():
    game_screen_size = get_viewport_rect().size
    player_width = $CollisionShape2D.shape.radius
    player_height = $CollisionShape2D.shape.height
    set_process(true)
    pass
    
func _physics_process(delta):
    velocity = move_and_slide(velocity)
    get_input()
    check_boundaries()

func get_input():
    velocity = Vector2(0,0)
    if(Input.is_action_pressed("move_left")):
        velocity.x = -speed
    if(Input.is_action_pressed("move_right")):
        velocity.x = speed
    if(Input.is_action_pressed("move_up")):
        velocity.y = -speed
    if(Input.is_action_pressed("move_down")):
        velocity.y = speed        
    if(Input.is_action_pressed("shoot")):
        self.activate_item()

  #Quit on Q press      
    if(Input.is_key_pressed(KEY_Q)):
        get_tree().quit()
    
func check_boundaries():
    self.position.x = clamp(self.position.x, 0 + player_width, game_screen_size.x-player_width)
    self.position.y = clamp(self.position.y, 0 + player_height, game_screen_size.y-player_height)


func activate_item():
    print('space pressed')
