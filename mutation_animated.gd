extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$mutation_sound.play()

func muta():
	pass

func _on_animation_finished() -> void:
	self.queue_free()
