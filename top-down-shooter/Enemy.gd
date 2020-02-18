extends Entity

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	DAMAGE = 1
	
func _physics_process(delta):
	movement_loop()
	damage_loop(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
