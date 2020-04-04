extends KinematicBody2D

var direction
enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}
onready var entity = get_node("entity")

export (PackedScene) var Laser 
signal shoot

func _ready() -> void:
    direction = DIRECTIONS.DOWN
    entity.shooting = false
    entity.shootTimer.connect("timeout", self, "shoot")

func shoot():
    if entity.shootTimer.time_left == 0:
        emit_signal("shoot", Laser, global_position, direction)
        entity.shooting = true
        entity.shootTimer.start()
