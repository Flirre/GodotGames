extends Node

export (int) var MAX_HEALTH = 1
onready var health = MAX_HEALTH setget set_health

signal no_health

func set_health(new_health):
	health = new_health
	if health <= 0:
		emit_signal("no_health")
