extends "res://Laser.gd"

func _on_EnemyLaser_body_entered(body: PhysicsBody2D) -> void:
    disappear()
    if(body.has_node('entity')):
        body.get_node('entity').take_damage(damage)
        body.get_node('entity').knockback(self.transform.origin - body.transform.origin, knockback)