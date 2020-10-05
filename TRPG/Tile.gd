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
onready var upNRay: RayCast = $Collisions/UpNeighbour
onready var downNRay: RayCast = $Collisions/DownNeighbour
onready var leftNRay: RayCast = $Collisions/LeftNeighbour
onready var rightNRay: RayCast = $Collisions/RightNeighbour
const DEBUG_NODE = "70"

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
		add_neighbour(upRay)
	if rightRay.is_colliding():
		add_neighbour(rightRay)
	if downRay.is_colliding():
		add_neighbour(downRay)
	if leftRay.is_colliding():
		add_neighbour(leftRay)
	if upNRay.is_colliding():
		add_neighbour(upNRay)
	if rightNRay.is_colliding():
		add_neighbour(rightNRay)
	if downNRay.is_colliding():
		add_neighbour(downRay)
	if leftNRay.is_colliding():
		add_neighbour(leftNRay)
	emit_signal("found_neighbours")


func add_neighbour(neighbourRay: RayCast):
	if not neighbours.has(neighbourRay.get_collider().owner):
		neighbours.push_back(neighbourRay.get_collider().owner)


func get_character():
	if aboveBodyRay.is_colliding():
		return aboveBodyRay.get_collider().owner
	else:
		return null


func check_availability():
	available = true
	if not is_free_above():
		available = false


func is_free_above():
	return not (aboveAreaRay.is_colliding() or aboveBodyRay.is_colliding())


func check_targetability():
	target = true
	if aboveAreaRay.is_colliding():
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
