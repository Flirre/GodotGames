extends Node2D

func _ready():
	pass

func _on_Player_shoot(laser, position, direction):
	var l = laser.instance()
	add_child(l)
	l.start(position, direction)


func _on_EnemyRobot_shoot(laser, position, direction) -> void:
	var l = laser.instance()
	call_deferred("add_child", l)
	l.start(position, direction)
