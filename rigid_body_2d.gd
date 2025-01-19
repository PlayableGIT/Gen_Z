extends RigidBody2D

# Zmienna do ustawienia celu (Destination) z poziomu edytora
@export var destination: NodePath

# Prędkość ruchu obiektu
@export var speed: float = 200.0

func _physics_process(delta: float):
	if destination:
		# Pobierz pozycję celu
		var target_position = get_node(destination).global_position

		# Oblicz nową pozycję przy użyciu interpolacji liniowej
		var new_position = global_position.lerp(target_position, speed * delta / global_position.distance_to(target_position))

		# Ustaw nową pozycję poprzez transformację
		global_position = new_position
