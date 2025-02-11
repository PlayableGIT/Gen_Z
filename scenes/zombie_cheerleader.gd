extends CharacterBody2D

# Zmienne ruchu obiektu
var direction = Vector2.ZERO
# Zmienne walki z survivorem
var survivor_in_range = false
var survivor_attack_cooldown = true
# Zmienne drzwi
var door_in_range = false
# Statystyki zombie
@export var speed = 250.0
@export var health = 10
var zombie_alive = true
var zombie_damage: int = 5
var ground_hit = true

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CPUParticles2D2.visible = true
	$CPUParticles2D2.one_shot = true
	$CPUParticles2D2.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var survivor = get_tree().get_nodes_in_group("survivor")
	if not is_on_floor():
		velocity += get_gravity() * 50 * delta
		velocity.x = 0.0
		move_and_slide()
	elif ground_hit == true:
		$ground_hit.visible = true
		$ground_hit.one_shot = true
		$ground_hit.emitting = true
		ground_hit = false
	if survivor.size() == 0:
		#$Zombie03.animation = "idle"
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
	set_Health_bar()
	
func moveCharacter():
	var closest = get_closest_player_or_null()
	#kierunek
	direction = global_position.direction_to(closest.global_position)
	
	#predkosc w kierunku
	velocity = direction.normalized() * speed
	if direction.normalized() <= Vector2(0, 0):
		$Sprite2D.set_flip_h(true)
	elif direction.normalized() >= Vector2(0, 0):
		$Sprite2D.set_flip_h(false)
		
func survivor_attack():
	if survivor_in_range and survivor_attack_cooldown:
		var damage = StatsAutoload.survivor_damage
		survivor_attack_cooldown = false
		#$Zombie03.animation = "attack"
		#$zombie_attack.play()
		$attack_cooldown.start()
		health = health - damage
		#$zombie_hurt.stop()
		#$zombie_hurt.play()
		#blood_splatter()
		print("Zombie took ", damage, " damage! Health: ", health)
		set_Health_bar()
		
	if survivor_in_range == false:
		pass
		#$Zombie03.animation = "walk"

func zombie():
	pass

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


func _on_bullet_zone_area_entered(area: Area2D) -> void:
	if area.has_method("bullet"):
		health -= StatsAutoload.survivor_gun_damage
		$zombie_hurt.stop()
		$zombie_hurt.play()
		#blood_splatter()
		print("Zombie took ", StatsAutoload.survivor_gun_damage, " damage! Health: ", health)

func set_Health_bar() -> void:
	$HealthBar.value = health
