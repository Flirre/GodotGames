extends Node2D

onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.play("Animate")


func _on_AnimatedSprite_animation_finished():
	queue_free()
