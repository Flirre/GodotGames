extends Spatial

class_name Game

var current_character: Character = null
var current_tile: Tile = null setget set_current_tile
var current_team: Object
var current_selection
var current_selection_index: int setget set_current_selection_index

onready var allies := $Allies
onready var enemies := $Enemies
onready var camera := $Camera
onready var teamLabel := $Camera/VBoxContainer/TeamLabel
onready var unitsLeftLabel := $Camera/VBoxContainer/UnitsLeft
onready var CurrentTurnLabel := $Camera/VBoxContainer/CurrentTurn
onready var unitActions := $Camera/UnitActions/VBoxContainer
onready var selectionArrow := $Camera/UnitActions/SelectionArrow
onready var tiles := $Tiles

var i: int
var moving := true
var current_units: int
var turns_spent: int setget handle_turns_spent
var game_turns := 1 setget handle_new_game_turn

enum GAME_STATE {MAP_CONTROL, UNIT_CONTROL, UNIT_MOVE, UNIT_ATTACK}
var state

func set_game_state(new_state):
	if new_state == GAME_STATE.UNIT_CONTROL:
		unitActions.visible = true
		selectionArrow.visible = true
	else:
		unitActions.visible = false
		selectionArrow.visible = false
	state = new_state

func _ready():
	setup_unit_signals()
	set_current_team(allies)
	current_units = current_team.get_child_count()
	self.turns_spent = 0
	yield(get_tree().create_timer(0.00000001), "timeout")
	self.current_tile = allies.get_child(0).get_tile()
	self.current_selection_index = 0
	set_game_state(GAME_STATE.MAP_CONTROL)

func setup_unit_signals():
	for ally in allies.get_children():
		ally.connect("unit_turn_finished", self, "handle_unit_turn_finished")
	for enemy in enemies.get_children():
		enemy.connect("unit_turn_finished", self, "handle_unit_turn_finished")

func handle_unit_turn_finished():
	self.turns_spent += 1
	if turns_spent >= current_units:
		switch_team()

func switch_team():
	yield(get_tree().create_timer(1), "timeout")
	for unit in current_team.get_children():
		unit.reset_status()
	if current_team == allies:
		set_current_team(enemies)
	else:
		set_current_team(allies)
		self.game_turns += 1
	current_units = current_team.get_child_count()
	self.turns_spent = 0
	self.current_tile = current_team.get_child(0).get_tile()

func set_current_team(team: Object) -> void:
	current_team = team
	teamLabel.text = current_team.name

func handle_turns_spent(val: int) -> void:
	turns_spent = val
	set_units_left_label(str(current_units - turns_spent))

func set_units_left_label(text: String) -> void:
	unitsLeftLabel.text = "Units left: " + str(text)

func handle_new_game_turn(val: int) -> void:
	CurrentTurnLabel.text = "Current Turn: " + str(val)
	game_turns = val

func _process(delta):
	if moving and current_tile:
		camera.move_to(current_tile.global_transform.origin, delta)
	match state:
		GAME_STATE.MAP_CONTROL:
			map_control_state(delta)
		GAME_STATE.UNIT_CONTROL:
			unit_control_state(delta)
		GAME_STATE.UNIT_MOVE:
			unit_move_state(delta)
		GAME_STATE.UNIT_ATTACK:
			unit_attack_state(delta)

func map_control_state(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		if is_body_above(current_tile) and valid_character_choice(current_tile.get_character()):
			set_current_character(current_tile.get_character())
			set_game_state(GAME_STATE.UNIT_CONTROL)
	control_tile()

func unit_control_state(_delta: float)->void:
	if Input.is_action_just_pressed("ui_up"):
		self.current_selection_index -= 1
	if Input.is_action_just_pressed("ui_down"):
		self.current_selection_index += 1
	if Input.is_action_just_pressed("ui_accept"):
		match current_selection.name:
			"Move":
				character_move()
			"Attack":
				character_attack()
			"Items":
				pass
		self.current_selection_index = 0

func character_move():
	current_character.active = true
	current_character.state = 1
	yield(current_character, "active_completed")
	for tile in tiles.get_children():
		if tile.available:
			tiles.enable_tile(tile)
		for neighbour in tile.neighbours:
			if tile.check_height(neighbour.global_transform.origin.y, current_character.jump):
				tiles.connect_points(tile, neighbour)
	set_game_state(GAME_STATE.UNIT_MOVE)

func character_attack():
	current_character.active = true
	current_character.state = 2
	yield(current_character, "active_completed")
	set_game_state(GAME_STATE.UNIT_ATTACK)

func set_current_selection_index(val: int):
	if val < 0:
		current_selection_index = unitActions.get_child_count() - 1
	elif val >= unitActions.get_child_count():
		current_selection_index = 0
	else:
		current_selection_index = val
	current_selection = unitActions.get_child(current_selection_index)
	selectionArrow.set_global_position(Vector2(selectionArrow.rect_global_position.x, current_selection.get_global_rect().position.y + 17) )
	

func unit_move_state(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if current_tile.available or current_tile == current_character.current_tile:
			move_character(delta)
	control_tile()
	
func unit_attack_state(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if current_tile.get_character() and current_tile.target or current_tile == current_character.current_tile:
			attack(current_tile.get_character())
	control_tile()

func attack(character: Character):
	if not character == current_character:	
		print('attacked ', character.name)
		current_character.active = false
		current_character = null
		yield(get_tree().create_timer(1), "timeout")
		set_game_state(GAME_STATE.MAP_CONTROL)
	else:
		set_game_state(GAME_STATE.UNIT_CONTROL)
		current_character.reset_character()

func valid_character_choice(character: Character) -> bool:
	return not character.turn_spent and character.get_parent_spatial() == current_team

func move_character(delta: float) -> void:
	if(current_tile != current_character.current_tile):
		current_character.move_to(tiles.aStar.get_future_point_path(int(current_character.get_tile().name), int(current_tile.name)), delta)
		yield(current_character, "move_completed")
	current_character.active = false
	current_character = null
	set_game_state(GAME_STATE.MAP_CONTROL)

func control_tile():
	if Input.is_action_just_pressed("ui_up"):
		move_to_ray(current_tile.upRay)
	if Input.is_action_just_pressed("ui_right"):
		move_to_ray(current_tile.rightRay)
	if Input.is_action_just_pressed("ui_down"):
		move_to_ray(current_tile.downRay)
	if Input.is_action_just_pressed("ui_left"):
		move_to_ray(current_tile.leftRay)

func move_to_ray(ray: RayCast):
	if ray.is_colliding() and not is_tile_above(ray.get_collider().owner):
		set_current_tile(ray.get_collider().owner)

func is_tile_above(tile: Tile):
	return tile.aboveAreaRay.is_colliding()

func is_body_above(tile: Tile):
	return tile.aboveBodyRay.is_colliding()

func set_current_tile(tile: Tile):
	if current_tile != null:
		current_tile.current = false
	current_tile = tile
	current_tile.current = true

func set_current_character(character: Character):
	for tile in tiles.get_children():
		tiles.disable_tile(tile)
		for neighbour in tile.neighbours:
				tiles.disconnect_points(tile, neighbour)
	if current_character:
		current_character.active = false
		yield(current_character, "inactive_completed")
	current_character = character
	set_current_tile(current_character.get_tile())

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and (event.scancode == KEY_Q):
			get_tree().quit()

func show_controls():
	unitActions.visible = true

func hide_controls():
	unitActions.visible = false
