extends Node

var game_over
onready var map = get_node("Map1")
onready var gui = get_node("GUI")

func _ready():
	gui.visible = false
	map.visible = true
	game_over = false
	
func _process(delta):
	if game_over:
		gui.visible = true
		map.visible = false

func _on_Player_shoot(laser, position, direction):
	var l = laser.instance()
	add_child(l)
	l.start(position, direction)


func _on_EnemyRobot_shoot(laser, position, direction) -> void:
	var l = laser.instance()
	call_deferred("add_child", l)
	l.start(position, direction)


func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_Player_game_over():
	print('gameover')
	game_over = true
