extends AStar

class_name NE_AStar

func _compute_cost(_from_id, _to_id):
	return 1.0

func _estimate_cost(_from_id, _to_id):
	return 1.0

#a-star probably ignores what is a possible path
func get_future_point_path(_from_id, _to_id):
	var point_path = get_point_path(_from_id, _to_id)
	point_path.remove(0)
	return point_path
