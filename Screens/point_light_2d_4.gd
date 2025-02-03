extends PointLight2D

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	var rng_light = rng.randf_range(0.0, 10.0)
	
	if rng_light <= 1:
		$".".energy = 1.4
	else:
		$".".energy = 1.45
