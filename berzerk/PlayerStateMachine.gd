extends "res://FiniteStateMachine.gd"
enum DIRECTIONS {UP, RIGHT, DOWN, LEFT}

func _ready():
    add_state("idle")
    add_state("running")
    add_state("shooting")
    call_deferred("set_state", states.idle)

func _state_logic(delta):
    parent.get_input()
    pass

func _get_transition(delta):
    match state:
        states.idle:
            if parent.velocity.length() > 0:
                return states.running
            if parent.shooting:
                return states.shooting
        states.running:
            if parent.velocity == Vector2.ZERO:
                return states.idle
            if parent.shooting:
                return states.shooting
        states.shooting:
            if not parent.shooting:
                if parent.velocity == Vector2.ZERO:
                    return states.idle
                if parent.velocity.length() > 0:
                    return states.running
    return null
    
func _enter_state(new_state, old_state):
    match new_state:
        states.idle:
            parent.animatedSprite.play("idle")
        states.running:
            parent.animatedSprite.play("running")
        states.shooting:
            parent.animatedSprite.play("shooting")
    pass

func _exit_state(old_state, new_state):
    pass
