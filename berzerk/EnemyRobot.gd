extends KinematicBody2D

export (int) var health

func _ready() -> void:
    $SpriteTimer.connect("timeout", self, "_timeout")
    
    
func _timeout():
    $AnimatedSprite.material.set_shader_param("white", false)

func take_damage(damage) -> void:
    $AnimatedSprite.material.set_shader_param("white", true)
    $SpriteTimer.start()
    health -= damage
    if health <= 0:
        get_parent().remove_child(self)