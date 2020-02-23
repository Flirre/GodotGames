extends Node2D
const BRICK = preload("res://Brick.tscn")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
        
func create_grid():
    for n in range(114):
        var new_brick = BRICK.instance()
        new_brick.position = Vector2(100 + (n % 17) * 50, (50 + 50 * floor(n/19)))
        add_child(new_brick)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    create_grid()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
