extends Spatial

class_name Tile

var available: bool = true
onready var availabilityIndicator = $AvailabilityIndicator
onready var aboveAreaRay = $TileMesh/Rays/AboveArea
onready var aboveBodyRay = $TileMesh/Rays/AboveBody
onready var leftRay = $TileMesh/Rays/Left
onready var rightRay = $TileMesh/Rays/Right
onready var upRay = $TileMesh/Rays/Up
onready var downRay = $TileMesh/Rays/Down

var character = null
var checked = false
var neighbours = []
var i = 0


func _ready():
	pass

func find_neighbours():
	#neighbours = []
	if upRay.is_colliding():
		neighbours.push_back(upRay.get_collider())
	if rightRay.is_colliding():
		neighbours.push_back(rightRay.get_collider())
	if downRay.is_colliding():
		neighbours.push_back(downRay.get_collider())
	if leftRay.is_colliding():
		neighbours.push_back(leftRay.get_collider())
	return neighbours
	
func find_all_neighbours_in_range(char_range: int):
	i = 0
	while i < char_range:
		if neighbours.size() == 0:
			find_neighbours()
		else:
			for neighbour in neighbours:
				neighbours += neighbour.owner.find_neighbours()
				#print_debug(neighbours)
		i += 1

	
func _process(delta):
	if not checked:
		if(aboveBodyRay.is_colliding()):
			available = false
			character = aboveBodyRay.get_collider()
			if character:
				available = false
				find_all_neighbours_in_range(character.owner.movement)
		if(aboveAreaRay.is_colliding()):
			available = false
			
		for neighbour in neighbours:
			neighbour.owner.available = false
			
		checked = true
		availabilityIndicator.visible = available
