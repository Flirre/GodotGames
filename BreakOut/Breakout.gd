extends Node2D
const ENEMY_SCENE = preload("res://Ball.tscn")
func spawn_enemy():
    print("spawning")
    var new_enemy = ENEMY_SCENE.instance()
    #Must have unique nodepath
    #Might be done automatically, but just in case
    new_enemy.set_name("Enemy" + str(get_child_count()))
    add_child(new_enemy)

func despawn_enemy(ball):
	ball.get_parent().remove_child(ball)
	
func handle_enemies(ball):
	despawn_enemy(ball)
	spawn_enemy()

func _ready():
    $Ball.connect("dead", self, "handle_enemies")
    pass
