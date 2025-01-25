extends CharacterBody2D

# Zmienne ruchu obiektu
var direction = Vector2.ZERO
# Zmienne walki z survivorem
var survivor_in_range = false
var survivor_in_gun_range = false
var survivor_attack_cooldown = true
# Zmienne drzwi
var door_in_range = false
# Statystyki zombie
@export var speed = 150.0
@export var health = 15
var zombie_alive = true
var zombie_damage: int = 5

func _ready() -> void:
	var total_dice_sides = 7
	$Zombie03.frame = randi() % total_dice_sides
	
func _physics_process(delta: float) -> void:
	#grawitacja
	var survivor = get_tree().get_nodes_in_group("survivor")
	
	if not is_on_floor():
		velocity += get_gravity() * 50 * delta
		velocity.x = 0.0
		move_and_slide()
		
	if survivor.size() == 0:
		$Zombie03.animation = "idle"
		pass
	else:
		move_and_slide()
		moveCharacter()
		survivor_attack()
	
	if health <= 0:
		zombie_alive = false
		health = 0
		print("Zombie has been killed!")
		self.queue_free()
	
func moveCharacter():
	var closest = get_closest_player_or_null()
	#kierunek
	direction = global_position.direction_to(closest.global_position)
	
	#predkosc w kierunku
	velocity = direction.normalized() * speed
	if direction.normalized() <= Vector2(0, 0):
		$Zombie03.set_flip_h(true)
	elif direction.normalized() >= Vector2(0, 0):
		$Zombie03.set_flip_h(false)

func zombie():
	pass
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("survivor"):
		survivor_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("survivor"):
		survivor_in_range = false
		
func survivor_attack():
	if survivor_in_range and survivor_attack_cooldown:
		#rng
		#var rng = RandomNumberGenerator.new()
		#var rng_damage = rng.randi_range(1, 10)
		var rng_damage = StatsAutoload.survivor_damage
		survivor_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		print("Zombie took ", rng_damage, " damage! Health: ", health)
	if survivor_in_gun_range and survivor_attack_cooldown:
		#rng
		var rng_damage = StatsAutoload.survivor_gun_damage
		survivor_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		print("Zombie took ", rng_damage, " damage! Health: ", health)

func _on_attack_cooldown_timeout() -> void:
	survivor_attack_cooldown = true


func _on_gun_area_body_entered(body: Node2D) -> void:
	if body.has_method("survivor_gun"):
		survivor_in_gun_range = true

func get_closest_player_or_null():
	var all_players = get_tree().get_nodes_in_group("survivor")
	var closest_player = null
	
	if(all_players.size()>0):
		closest_player = all_players[0]
		for player in all_players:
			var distance_to_this_player = global_position.distance_squared_to(player.global_position)
			var distance_to_closest_player = global_position.distance_squared_to(closest_player.global_position)
			if (distance_to_this_player < distance_to_closest_player):
				closest_player = player
	return closest_player

func _on_gun_area_body_exited(body: Node2D) -> void:
	if body.has_method("survivor_gun"):
		survivor_in_gun_range = false
