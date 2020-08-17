extends Spatial

class_name Tile

var available: bool
var current: bool
onready var availabilityIndicator: MeshInstance = $AvailabilityIndicator
onready var currentIndicator: CSGCombiner = $CurrentIndicator
onready var aboveAreaRay: RayCast = $Collisions/AboveArea
onready var aboveBodyRay: RayCast = $Collisions/AboveBody
onready var leftRay: RayCast = $Collisions/Left
onready var rightRay: RayCast = $Collisions/Right
onready var upRay: RayCast = $Collisions/Up
onready var downRay: RayCast = $Collisions/Down

var checked: bool = false
var neighbours: Array = []
var i: int = 0

signal clicked
signal found_neighbours

func _ready():
	current = false
	available = false
	checked = false
	neighbours = []

func find_neighbours():
	neighbours = []
	if upRay.is_colliding():
		neighbours.push_back(upRay.get_collider().owner)
	if rightRay.is_colliding():
		neighbours.push_back(rightRay.get_collider().owner)
	if downRay.is_colliding():
		neighbours.push_back(downRay.get_collider().owner)
	if leftRay.is_colliding():
		neighbours.push_back(leftRay.get_collider().owner)

func get_character():
	if aboveBodyRay.is_colliding():
		return aboveBodyRay.get_collider().owner
	else:
		return null

func check_availability():
	available = true
	if(aboveBodyRay.is_colliding()):
		available = false
	if(aboveAreaRay.is_colliding()):
		available = false

func check_height(height: float, jump: int):
	return true

func _process(_delta):
	availabilityIndicator.visible = available
	currentIndicator.visible = current
