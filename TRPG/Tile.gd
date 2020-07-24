extends Spatial

class_name Tile

var available: bool
onready var availabilityIndicator: MeshInstance = $AvailabilityIndicator
onready var aboveAreaRay: RayCast = $TileMesh/Rays/AboveArea
onready var aboveBodyRay: RayCast = $TileMesh/Rays/AboveBody
onready var leftRay: RayCast = $TileMesh/Rays/Left
onready var rightRay: RayCast = $TileMesh/Rays/Right
onready var upRay: RayCast = $TileMesh/Rays/Up
onready var downRay: RayCast = $TileMesh/Rays/Down

var character: Character = null
var checked: bool = false
var neighbours: Array = []
var i: int = 0


func _ready():
	available = false
	checked = false
	neighbours = []

func find_neighbours():
	#neighbours = []
	if upRay.is_colliding():
		neighbours.push_back(upRay.get_collider().owner)
	if rightRay.is_colliding():
		neighbours.push_back(rightRay.get_collider().owner)
	if downRay.is_colliding():
		neighbours.push_back(downRay.get_collider().owner)
	if leftRay.is_colliding():
		neighbours.push_back(leftRay.get_collider().owner)
	return neighbours

func find_all_neighbours_in_range(char_range: int):
	i = 0
	while i < char_range:
		if neighbours.size() == 0:
			find_neighbours()
		else:
			for neighbour in neighbours:
				neighbours += neighbour.find_neighbours()
		i += 1


func _process(_delta):
	if not checked:
		if(aboveBodyRay.is_colliding()):
			available = false
			character = aboveBodyRay.get_collider().owner
			if character:
				available = false
				find_all_neighbours_in_range(character.movement)
		for neighbour in neighbours:
			neighbour.available = true

		if(aboveAreaRay.is_colliding()):
			available = false

		checked = true
	availabilityIndicator.visible = available
