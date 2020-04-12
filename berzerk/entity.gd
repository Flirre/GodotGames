extends Node

export (int) var speed
export (int) var health
export (int) var weight
var shooting: bool 
var velocity: Vector2


onready var shootTimer = get_node("ShootTimer")
onready var spriteTimer = get_node("SpriteTimer")
onready var animatedSprite = get_parent().get_node("AnimatedSprite")
onready var kinematicBody = get_parent()

func _ready() -> void:
	spriteTimer.connect("timeout", self, "_timeout")

func _timeout():
	animatedSprite.material.set_shader_param("white", false)

func take_damage(damage) -> void:
	animatedSprite.material.set_shader_param("white", true)
	spriteTimer.start()
	health -= damage
	if health <= 0:
		kinematicBody.get_parent().remove_child(kinematicBody)

func knockback(knockback_direction, knockback_strength) -> void:
	kinematicBody.move_and_slide(-knockback_direction.normalized() * knockback_strength / weight)
	
func _physics_process(delta):
	velocity = kinematicBody.move_and_slide(velocity)
	if shootTimer.time_left == 0:
		shooting = false
