extends Node

export (int) var max_health = 1 setget set_max_health

var health = max_health setget set_health
var magic_points = 10

var level = 1
var experience_points = 0 setget set_exp

var strength = 10
var intelligence = 10

var wisdom = 10
var constitution = 10

var agility = 10

var charisma = 10

var luck = 1

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


func set_exp(experience):
	experience_points = experience
	if experience_points >= 100:
		level_up()


func _ready():
	self.health = max_health


func level_up():
	self.level += 1
	print('new level: ', self.level)
