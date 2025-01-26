extends Area2D

var speed = 750

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D):
	if body.has_method("survivor"):
		pass
	if body.has_method("zombie"):
		queue_free()
	if body.has_method("door"):
		queue_free()

func bullet():
	pass
