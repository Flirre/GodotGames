extends Node

export (int) var max_health = 1 setget set_max_health
export (int) var max_mana = 1 setget set_max_mana

export var char_name := "default_name"

var health = max_health setget set_health
var mana = 10

var level = 1
var experience_points = 0 setget set_exp

var strength = 1
var intelligence = 10

var wisdom = 10
var constitution = 10

var agility = 10

var charisma = 10

var luck = 1

signal no_health
signal health_changed(new_health)
signal max_health_changed(new_max_health)

signal mana_changed(new_mana)
signal max_mana_changed(new_max_mana)


func set_health(new_health):
    health = new_health
    emit_signal("health_changed", new_health)
    if health <= 0:
        emit_signal("no_health")


func set_max_health(new_max_health):
    max_health = new_max_health
    self.health = min(health, max_health)
    emit_signal("max_health_changed", new_max_health)

func set_max_mana(new_max_mana):
    max_mana = new_max_mana
    self.mana = min(mana, max_mana)
    emit_signal("max_mana_changed", new_max_mana)
    

func set_exp(experience):
    experience_points = experience
    if experience_points >= 100:
        level_up()


func _ready():
    self.health = max_health


func level_up():
    self.level += 1
    print('new level: ', self.level)
