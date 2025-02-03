extends Sprite2D
var speed = 10
var zmiana_y = 0
var zmiana_x = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	zmiana_y -= speed*delta 
	zmiana_x -= speed*delta
	$".".texture.noise.offset = Vector3(zmiana_x, zmiana_y, 0)
