extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func muta():
	pass

func _on_animation_finished() -> void:
	self.queue_free()
