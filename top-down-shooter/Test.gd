extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$ParallaxBackground/space.motion_mirroring = $ParallaxBackground/space/sprite.texture.get_size().rotated($ParallaxBackground/space/sprite.global_rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll = Vector2(0,0.80) #Some default scrolling so there's always movement.
	$ParallaxBackground.scroll_offset += scroll
