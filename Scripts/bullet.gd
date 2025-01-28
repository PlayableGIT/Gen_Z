extends Area2D

var speed = 750

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	if $".".position > Vector2(1500,0):
		position += transform.y * speed * delta * 0.1
	if $".".position > Vector2(2700,0):
		queue_free()

func _on_body_entered(body: Node2D):
	if body.has_method("survivor"):
		pass
	else: 
		queue_free()

func bullet():
	pass
