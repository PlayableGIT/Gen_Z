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

@export var health = 20
var zombie_alive = true
var zombie_damage: int = 5
var ground_hit = true
var surv_in_range_gun = false


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

	velocity = Vector2(velocity.x, 0)
	if direction.normalized() <= Vector2(0, 0):
		$Sprite2D.set_flip_h(true)
	elif direction.normalized() >= Vector2(0, 0):
		$Sprite2D.set_flip_h(false)
		
func survivor_attack():
	if survivor_in_range and survivor_attack_cooldown:
		var damage = StatsAutoload.survivor_damage
		survivor_attack_cooldown = false
		#$Zombie03.animation = "attack"
		$zombie_attack.play()
		$attack_cooldown.start()
		health = health - damage
		$zombie_hurt.stop()
		$zombie_hurt.play()
		blood_splatter()
		print("Zombie took ", damage, " damage! Health: ", health)
	if surv_in_range_gun and survivor_attack_cooldown:
		survivor_attack_cooldown = false
		#$Zombie03.animation = "attack"
		$zombie_attack.play()
		$attack_cooldown.start()
		$zombie_hurt.stop()
		$zombie_hurt.play()
		blood_splatter()
		
	if survivor_in_range == false and surv_in_range_gun == false:
		pass
		#$Zombie03.animation = "walk"

func zombie():
	pass

func cheerleader():
	pass

func blood_splatter():
	var splat_x = rng.randf_range(-50.0, 50.0)
	var splat_y = rng.randf_range(-50.0, 50.0)
	var splatter_position = Vector2(splat_x, splat_y)
	$blood_splatter.position = splatter_position
	$blood_splatter.visible = true
	$blood_splatter.one_shot = true
	$blood_splatter.emitting = true

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
		blood_splatter()
		print("Zombie took ", StatsAutoload.survivor_gun_damage, " damage! Health: ", health)

func set_Health_bar() -> void:
	$HealthBar.value = health



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("survivor"):
		print("1")
		survivor_in_range = true
	if body.has_method("survivor_gun"):
		print("2")
		survivor_in_range = true
		surv_in_range_gun = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("survivor"):
		survivor_in_range = false
	if body.has_method("survivor_gun"):
		survivor_in_range = false
		surv_in_range_gun = false


func _on_attack_cooldown_timeout() -> void:
	survivor_attack_cooldown = true



func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.has_method("zombie") and body.has_method("cheerleader") == false:
		body.add_to_group("healing")
		print("healing")
	


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.has_method("zombie") and body.has_method("cheerleader") == false:
		body.remove_from_group("healing")
		print("wyszedl z healing")
