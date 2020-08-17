extends Spatial

var tiles
var aStar: NE_AStar = preload("res://Non-Euclidian-astar.gd").new()

func _ready():
	yield(get_tree().create_timer(0.00000001), "timeout")
	aStar.reserve_space(self.get_child_count())
	for tile in get_children():
		aStar.add_point(int(tile.name), tile.global_transform.origin)
		tile.find_neighbours()
		for neighbour in tile.neighbours:
			if(not neighbour.aboveAreaRay.is_colliding()):
				aStar.connect_points(int(tile.name), int(neighbour.name))
	for point in aStar.get_points():
		aStar.set_point_disabled(point)

func disable_tile(tile):
	aStar.set_point_disabled(int(tile.name))

func enable_tile(tile):
	aStar.set_point_disabled(int(tile.name), false)

func check_tile(tile):
	print(aStar.is_point_disabled(int(tile.name)))

func print_all_enabled_points():
	for point in aStar.get_points():
		if(not aStar.is_point_disabled(point)):
			print(point)
