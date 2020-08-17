extends Spatial

class_name Character

enum TEAMS {ALLIES, ENEMIES, NEUTRAL}

export (int) var movement = 2
export (int) var speed = 5
export (int) var jump = 2

var active := false
var current_tile = null
export (int) var team
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
	find_possible_movement(movement, jump)
	emit_signal("active_completed")

func find_possible_movement(possible_movement: int, jump: int):
	poss_moves = []
	for tile in current_tile.neighbours:
		if not opposing_teams(tile.get_character()) and current_tile.check_height(tile.global_transform.origin.y, jump):
			poss_moves = poss_moves + [tile]
	for _i in range(possible_movement - 1):
		for move in poss_moves:
			for poss_new_move in move.neighbours:
				if not poss_new_move in poss_moves and not opposing_teams(poss_new_move.get_character()) and move.check_height(poss_new_move.global_transform.origin.y, jump):
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

func opposing_teams(character: Character):
	if character == null:
		return false
	return team != character.team

func move_to(path: Array, _delta: float):
	for tile in path:
		tween.interpolate_property(self, "translation", self.transform.origin, tile + Vector3(0, 2, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_completed")
	emit_signal("move_completed")

func _process(_delta):
	if active and current_tile == null:
		on_active()
	if not active and not current_tile == null:
		exit_active()

func reset_status() -> void:
	self.turn_spent = false
