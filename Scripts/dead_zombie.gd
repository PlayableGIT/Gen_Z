extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$blood_splatter.visible = true
	$blood_splatter.one_shot = true
	$blood_splatter.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
