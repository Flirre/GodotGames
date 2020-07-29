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
	var result = current_character.on_active()
	yield(get_tree().create_timer(0.00000001), "timeout")
	print(current_character)
	print(current_character.current_tile)
	current_tile = current_character.current_tile

func _process(delta):
	if moving and current_tile:
		camera.move_to(current_tile.global_transform.origin, delta)
	if Input.is_action_just_pressed("ui_accept"):
		i += 1
		get_next_character()

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
	yield(get_tree().create_timer(0.00000001), "timeout")
	current_character.active = true
	current_tile = current_character.current_tile
	current_character.move_to()

#func _input(event):
#   # Mouse in viewport coordinates
#   if event is InputEventMouseButton:
#	   print("Mouse Click/Unclick at: ", event)
