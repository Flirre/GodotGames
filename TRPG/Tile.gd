extends Spatial

class_name Tile

var available: bool
var current: bool
var target: bool
onready var availabilityIndicator: MeshInstance = $AvailabilityIndicator
onready var currentIndicator: CSGCombiner = $CurrentIndicator
onready var rangeIndicator: MeshInstance = $RangeIndicator
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
	emit_signal("found_neighbours")

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

func check_targetability():
	target = true
	if(aboveAreaRay.is_colliding()):
		target = false

func check_height(target_height: float, jump: int = 0):
	var self_height = self.global_transform.origin.y
	if target_height >= self_height:
		return (target_height - self_height) <= jump
	if target_height < self_height:
		return (self_height - target_height) <= (jump + 1)

func _process(_delta):
	availabilityIndicator.visible = available
	currentIndicator.visible = current
	rangeIndicator.visible = target
