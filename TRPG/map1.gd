extends Spatial

var tiles

func _ready():
	yield(get_tree().create_timer(0.00000001), "timeout")
	for tile in get_children():
		tile.find_neighbours()
