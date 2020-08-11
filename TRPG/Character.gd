extends Spatial

class_name Character

export (int) var movement = 2
export (int) var speed = 5
var active := false
var current_tile = null
onready var tileRay = $CurrentTile
onready var tween = $Tween
onready var endSign = $END
var poss_moves = []
var turn_spent setget set_turn_spent

func set_turn_spent(val: bool):
	endSign.visible = val
	turn_spent = val

signal active_completed
signal inactive_completed
signal movement_completed
signal move_completed
signal unit_turn_finished

func _ready():
	if active:
		on_active()

func get_tile():
	return tileRay.get_collider().owner

func on_active():
	current_tile = tileRay.get_collider().owner
	poss_moves = current_tile.neighbours
	find_possible_movement(movement)
	emit_signal("active_completed")

func find_possible_movement(movement: int):
	for i in range(movement - 1):
		for move in poss_moves:
			var new_moves = move.neighbours
			for poss_new_move in new_moves:
				if not poss_new_move in poss_moves:
					poss_moves = poss_moves + [poss_new_move]
	for tile in poss_moves:
		tile.check_availability()

func exit_active():
	for tile in poss_moves:
		tile.available = false
	current_tile = null
	poss_moves = []
	self.turn_spent = true
	emit_signal("inactive_completed")
	emit_signal("unit_turn_finished")

func move_to(tile: Tile, delta: float):
	tween.interpolate_property(self, "translation", self.transform.origin, tile.transform.origin + Vector3(0, 2, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("move_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active and current_tile == null:
		on_active()
	if not active and not current_tile == null:
		exit_active()

func reset_status() -> void:
	self.turn_spent = false
