extends Spatial

class_name Tile

var available: bool
var current: bool
onready var availabilityIndicator: MeshInstance = $AvailabilityIndicator
onready var currentIndicator: CSGCombiner = $CurrentIndicator
onready var aboveAreaRay: RayCast = $Rays/AboveArea
onready var aboveBodyRay: RayCast = $Rays/AboveBody
onready var leftRay: RayCast = $Rays/Left
onready var rightRay: RayCast = $Rays/Right
onready var upRay: RayCast = $Rays/Up
onready var downRay: RayCast = $Rays/Down

var checked: bool = false
var neighbours: Array = []
var i: int = 0

signal clicked

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

func check_availability():
	available = true
	if(aboveBodyRay.is_colliding()):
		available = false
	if(aboveAreaRay.is_colliding()):
		available = false

func _process(_delta):
	if not checked:
		checked = true
		#check_availability()
	availabilityIndicator.visible = available
	currentIndicator.visible = current

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("yowza")
		emit_signal("clicked", self)
