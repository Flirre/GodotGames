extends Node2D

func _ready():
    pass

func _on_Player_shoot(laser, position, direction):
    var l = laser.instance()
    add_child(l)
    l.start(position, direction)
