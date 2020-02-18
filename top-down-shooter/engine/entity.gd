class_name Entity
extends KinematicBody2D

var SPEED: int = 0
var movement_direction: Vector2 = Vector2(0,0)
var knockback_direction: Vector2 = Vector2(0,0)
var stun_timer: float = 0.0
var STUN_TIME: float = 0.2

var RELOAD_TIME: float = 0.0
var reloading: float = 0.0

var health: int = 5
var blinking_time: float = 0.0

var DAMAGE: int = 0

func take_damage(damage: int):
	if isNotStunned():
		start_blink()
		health = health - damage
		if health <= 0:
			die()

func isNotStunned():
	return !isStunned()

func isStunned():
	return stun_timer > 0

func start_blink():
	blinking_time = .1

func die():
	queue_free()

func readyToFire():
	return (reloading <= 0.0)

func movement_loop():
	var normalized_movement = calculate_movement().normalized()
	# warning-ignore:return_value_discarded
	move_and_slide(normalized_movement * SPEED, Vector2(0,0))
	if(isColliding()):
		var collision = get_slide_collision(0)
		var collider = collision.collider
		
		if collision and collider.has_method('isEntity'):
			handleCollision(collider)
			knockback_direction = transform.origin - collider.transform.origin

func isColliding():
	return get_slide_count() > 0
			
func handleCollision(collider):
	handleCollisionDamage(collider)
	resetStunTimer()
	
func resetStunTimer():
	stun_timer = STUN_TIME
	
func handleCollisionDamage(collider):
	take_damage(collider.DAMAGE)

func calculate_movement():
	if isNotStunned():
		return movement_direction
	else:
		return knockback_direction
	
	
func damage_loop(delta):
	if stun_timer >= 0.0:
		stun_timer -= delta
	blink(delta)
		
func blink(delta):
	if blinking_time > 0.0:
		$Sprite.modulate = Color(10,10,10)
		blinking_time -= delta
	else:	
		$Sprite.modulate = Color(1,1,1)
		
func isEntity():
	return true

func _ready():
	pass
