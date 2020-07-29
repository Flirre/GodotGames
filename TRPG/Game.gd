extends Spatial

var current_character: Character = null
var current_tile: Tile = null
var current_team: Object
onready var allies = $Allies
onready var enemies = $Enemies
onready var camera = $Camera
var i: int
var moving := true

func _ready():
	current_team = allies
	current_character = current_team.get_child(0)
	yield(get_tree().create_timer(0.00000001), "timeout")
	current_character.active = true
	yield(current_character, "active_completed")
	current_tile = current_character.current_tile

func _process(delta):
	if moving and current_tile:
		camera.move_to(current_tile.global_transform.origin, delta)
	if Input.is_action_just_pressed("ui_accept"):
		if is_body_above(current_tile):
			print(get_character_on_tile(current_tile))
	control_tile()

func get_character_on_tile(tile: Tile):
	return tile.aboveBodyRay.get_collider().owner

func control_tile():
	if Input.is_action_just_pressed("ui_up"):
		move_to_ray(current_tile.upRay)
	if Input.is_action_just_pressed("ui_right"):
		move_to_ray(current_tile.rightRay)
	if Input.is_action_just_pressed("ui_down"):
		move_to_ray(current_tile.downRay)
	if Input.is_action_just_pressed("ui_left"):
		move_to_ray(current_tile.leftRay)

func move_to_ray(ray: RayCast):
	if ray.is_colliding() and not is_tile_above(ray.get_collider().owner):
		set_current_tile(ray.get_collider().owner)

func is_tile_above(tile: Tile):
	return tile.aboveAreaRay.is_colliding()

func is_body_above(tile: Tile):
	return tile.aboveBodyRay.is_colliding()

func set_current_tile(tile: Tile):
	current_tile.current = false
	current_tile = tile
	current_tile.current = true

func get_next_character():
	if not i >= current_team.get_child_count():
		update_current_character(i)
	else:
		i = 0
		if current_team == allies:
			current_team = enemies
		else:
			current_team = allies
		get_next_character()

func update_current_character(index):
	current_character.active = false
	current_character = current_team.get_child(index)
#	yield(get_tree().create_timer(0.00000001), "timeout")
	current_character.active = true
	yield(current_character, "active_completed")
	set_current_tile(current_character.current_tile)
#	current_character.move_to()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and (event.scancode == KEY_ESCAPE or event.scancode == KEY_Q):
			get_tree().quit()
