extends Spatial

var available: bool = true
onready var availabilityIndicator = $AvailabilityIndicator
onready var aboveRay = $TileMesh/Spatial/Above

var character = null
var checked = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not checked and not character:
		if(aboveRay.is_colliding()):
			character = aboveRay.get_collider()
			available = false
		availabilityIndicator.visible = available
		checked = true
		print(character)
