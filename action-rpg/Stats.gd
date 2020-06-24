extends Node

export (int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(new_health)
signal max_health_changed(new_max_health)

func set_health(new_health):
	health = new_health
	emit_signal("health_changed", new_health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(new_max_health):
	max_health = new_max_health
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func _ready():
	self.health = max_health
