extends Area2D

var speed = 750

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(_body):
	queue_free()

func bullet():
	pass
