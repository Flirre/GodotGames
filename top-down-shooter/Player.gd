extends Entity

const LASER = preload("res://Laser.tscn")

# Sets the constants from the Entity class when readying
func _ready():
	SPEED = 200
	RELOAD_TIME = 0.5
	DAMAGE = 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	reloading -= delta

# warning-ignore:unused_argument
func _physics_process(delta):
	input_loop()
	movement_loop()
	damage_loop(delta)

func input_loop():
	var LEFT 	= Input.is_action_pressed("move_left")
	var UP 		= Input.is_action_pressed("move_up")
	var RIGHT 	= Input.is_action_pressed("move_right")
	var DOWN 	= Input.is_action_pressed("move_down")
	var FIRE 	= Input.is_action_pressed("fire")
	
	movement_direction.x = -int(LEFT) + int(RIGHT)
	movement_direction.y = -int(UP) + int(DOWN)
	
	if (LEFT):
		turn_left()
		
	if (RIGHT):
		turn_right()
		
	if(not_turning()):
		stop_turning()
	
	if (FIRE):
		fire()
		
func turn_left():
	$Sprite.flip_h = false
	$animation.play("turning")
	
func turn_right():
	$Sprite.flip_h = true
	$animation.play("turning")

func stop_turning():
	$Sprite.flip_h = false
	$animation.play("idle")

func not_turning():
	return movement_direction.x == 0
	
func not_moving():
	return movement_direction.y == 0

func is_idle():
	return not_turning() and not_moving()

func fire():
	if readyToFire():
		var left_laser = LASER.instance()
		var right_laser = LASER.instance()

		left_laser.global_position = global_position
		left_laser.position.x -= 34
		left_laser.position.y -= 27

		right_laser.global_position = global_position
		right_laser.position.x += 35
		right_laser.position.y -= 27

		get_parent().add_child(left_laser)
		get_parent().add_child(right_laser)
		reloading = RELOAD_TIME
