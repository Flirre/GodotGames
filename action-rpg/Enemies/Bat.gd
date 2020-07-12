extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200

enum {IDLE, WANDER, CHASE}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var stats = $Stats
onready var player_detection = $PlayerDetection
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var animation_player = $AnimationPlayer

func _ready():
	state = pick_random_state([WANDER, IDLE])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_wander()
			
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([WANDER, IDLE])
				wander_controller.start_wander_timer(rand_range(1,3))
				accelerate_towards_point(wander_controller.target_position, delta)
				
				if global_position.distance_to(wander_controller.target_position) <= MAX_SPEED * delta:
					update_wander()
			
		CHASE:
			var player = player_detection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 300
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point: Vector2, delta):
	var target_position = global_position.direction_to(point)
	velocity = velocity.move_toward(target_position * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1,3))

func seek_player():
	if player_detection.can_see_player():
		state = CHASE
	
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area: Hitbox):
	stats.health -= area.damage
	knockback = area.knockback_vector * 125
	hurtbox._create_hit_effect()
	hurtbox.start_invincibility(0.3)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animation_player.play("start")


func _on_Hurtbox_invincibility_ended():
	animation_player.play("stop")
