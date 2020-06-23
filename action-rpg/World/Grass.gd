extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
		var grassEffect = GrassEffect.instance()
		var world = get_parent()
		grassEffect.global_position = global_position
		world.add_child(grassEffect)

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
