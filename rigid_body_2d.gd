extends RigidBody2D

# Zmienna do ustawienia celu (Destination) z poziomu edytora
@export var destination: NodePath

# Prędkość ruchu obiektu
@export var speed: float = 100.0

func _physics_process(delta: float):
	if destination:
		# Pobierz pozycję celu
		var target_position = get_node(destination).global_position

		# Oblicz nową pozycję przy użyciu interpolacji liniowej
		var new_position = global_position.lerp(target_position, speed * delta / global_position.distance_to(target_position))

		# Ustaw nową pozycję poprzez transformację
		global_position = new_position
		_odleglosc()
		#print(new_position.x)
func _odleglosc():
	var target_position = get_node(destination).global_position
	var dystans = target_position-global_position
	if (dystans<=Vector2(150,0)):
		global_position =- Vector2(-780,100)
	
