extends AnimatedSprite


func _ready():
    pass

# polling - runs every frame
func _physics_process(delta):
    if Input.is_action_pressed("move_right"):
        # move as long as the key/button is pressed
        position.x += speed * delta
    if Input.is_action_pressed("move_left"):
        # move as long as the key/button is pressed
        position.x -= speed * delta
    if Input.is_action_pressed("move_down"):
        # move as long as the key/button is pressed
        position.y += speed * delta
    if Input.is_action_pressed("move_up"):
        # move as long as the key/button is pressed
        position.y -= speed * delta
    if(Input.is_key_pressed(KEY_Q)):
        get_tree().quit()
