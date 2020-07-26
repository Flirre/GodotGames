extends Spatial

var current_character: Character = null
var current_team: Object
onready var allies = $Allies
onready var enemies = $Enemies
onready var camera = $Camera
var i: int
var moving := true

func _ready():
	current_team = allies
	current_character = current_team.get_child(0)
#	camera.move_to(current_character.global_transform.origin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		camera.move_to(current_character.global_transform.origin, delta)
	if Input.is_action_just_pressed("ui_accept"):
		i += 1
		get_next_character()

func get_next_character():
	print()
	print(i)
	if not i >= current_team.get_child_count():
		current_character = current_team.get_child(i)
		
	else:
		i = 0
		if current_team == allies:
			current_team = enemies
		else:
			current_team = allies
		get_next_character()
