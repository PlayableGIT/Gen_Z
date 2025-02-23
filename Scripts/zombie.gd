extends CharacterBody2D

# Zmienne ruchu obiektu
var direction = Vector2.ZERO
# Zmienne walki z survivorem
var survivor_in_range = false
var survivor_attack_cooldown = true
# Zmienne drzwi
var door_in_range = false
# Statystyki zombie
@export var speed = 100
@export var health = 30
var zombie_alive = true
var zombie_damage: int = 5
var ground_hit = true
var spawn_ready = false
var xd = false
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$PointLight2D3.visible = false
	$Control2/TextureButton.visible = false
	$Control3/left_mutation.visible = false
	add_to_group("zombie")
	var total_dice_sides = 7
	$Zombie03.frame = randi() % total_dice_sides
	var rng_play = rng.randf_range(0.0, 20.0)
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	$zombie_walk.pitch_scale = rng_pitch_number
	$zombie_walk.play(rng_play)
	$CPUParticles2D2.visible = true
	$CPUParticles2D2.one_shot = true
	$CPUParticles2D2.emitting = true
	
func _physics_process(delta: float) -> void:
	#grawitacja
	#print($".", "right: ", mut_cand_right.size())
	#print($".", "left: ", mut_cand_left.size())
	
	if mut_cand_right.size() == 1 and mut_cand_left.size() == 0 and $Control2/TextureButton.visible == true:
		$Control2/TextureButton.visible = true
	else:
		pass
	if mut_cand_left.size() == 1 and mut_cand_right.size() == 0 and $Control2/TextureButton.visible == true:
		$Control3/left_mutation.visible = true 
	else:
		pass

	var survivor = get_tree().get_nodes_in_group("survivor")
	if $Zombie03.flip_h == true:
		add_to_group("left")
		remove_from_group("right")
	if $Zombie03.flip_h == false:
		add_to_group("right")
		remove_from_group("left")
	
	if not is_on_floor():
		velocity += get_gravity() * 45 * delta
		velocity.x = 0.0
		move_and_slide()
	elif ground_hit == true:
		$ground_hit.visible = true
		$ground_hit.one_shot = true
		$ground_hit.emitting = true
		ground_hit = false
		
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
	set_Health_bar()
	
func moveCharacter():
	var closest = get_closest_player_or_null()
	#kierunek
	direction = global_position.direction_to(closest.global_position)
	
	#predkosc w kierunku
	velocity = direction.normalized() * speed
	velocity = Vector2(velocity.x, 0)
	if direction.normalized() <= Vector2(0, 0):
		$Zombie03.set_flip_h(true)
	elif direction.normalized() >= Vector2(0, 0):
		$Zombie03.set_flip_h(false)

func blood_splatter():
	var splat_x = rng.randf_range(-50.0, 50.0)
	var splat_y = rng.randf_range(-50.0, 50.0)
	var splatter_position = Vector2(splat_x, splat_y)
	$blood_splatter.position = splatter_position
	$blood_splatter.visible = true
	$blood_splatter.one_shot = true
	$blood_splatter.emitting = true

func zombie():
	pass

var surv_in_range_gun = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("survivor"):
		survivor_in_range = true
	if body.has_method("survivor_gun"):
		survivor_in_range = false
		surv_in_range_gun = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("survivor"):
		survivor_in_range = false
	if body.has_method("survivor_gun"):
		surv_in_range_gun = false
		survivor_in_range = false
		
func survivor_attack():
	if survivor_in_range and survivor_attack_cooldown:
		var damage = StatsAutoload.survivor_damage
		survivor_attack_cooldown = false
		$Zombie03.animation = "attack"
		$zombie_attack.play()
		$attack_cooldown.start()
		health = health - damage
		$zombie_hurt.stop()
		$zombie_hurt.play()
		blood_splatter()
		print("Zombie took ", damage, " damage! Health: ", health)
	if surv_in_range_gun and survivor_attack_cooldown:
		survivor_attack_cooldown = false
		$Zombie03.animation = "attack"
		$zombie_attack.play()
		$attack_cooldown.start()
		$zombie_hurt.stop()
		$zombie_hurt.play()
		blood_splatter()
	if survivor_in_range == false and surv_in_range_gun == false:
		$Zombie03.animation = "walk"
		

func _on_attack_cooldown_timeout() -> void:
	survivor_attack_cooldown = true

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
		print("bang")
		health -= StatsAutoload.survivor_gun_damage
		$zombie_hurt.stop()
		$zombie_hurt.play()
		blood_splatter()
		print("Zombie took ", StatsAutoload.survivor_gun_damage, " damage! Health: ", health)


func _on_zombie_walk_finished() -> void:
	$zombie_walk.play()

func set_Health_bar() -> void:
	$HealthBar.value = health


func _on_button_pressed() -> void:
	print("toggle")
	if $Control2/TextureButton.visible == false and mut_cand_right.size() > 0:
		$Control2/TextureButton.visible = true
		$PointLight2D3.visible = true
	else:
		$Control2/TextureButton.visible = false
		$PointLight2D3.visible = false
		
	if $Control3/left_mutation.visible == false and mut_cand_left.size() > 0:
		$Control3/left_mutation.visible = true
		$PointLight2D3.visible = true
	else:
		$Control3/left_mutation.visible = false
		$PointLight2D3.visible = false


func _on_texture_button_pressed() -> void:
	$".".add_to_group("mutation")
	if mut_cand_right.size() > 0:
		if mut_cand_right[0] != null:
			mut_cand_right[0].add_to_group("mutation")
			print("mutacja")

func _on_left_mutation_pressed() -> void:
	$".".add_to_group("mutation")
	if mut_cand_left.size() > 0:
		if mut_cand_left[0] != null:
			mut_cand_left[0].add_to_group("mutation")
			print("mutacja")

var mut_cand_left: = []
var mut_cand_right: = []
func _on_right_skillzone_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		mut_cand_right.append(body)
		print(body)
		print("Prawa mutacja kandydat wszedł")


func _on_right_skillzone_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		mut_cand_right.erase(body)
		print(body)
		print("Prawa mutacja kandydat wyszedł")


func _on_left_skillzone_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		mut_cand_left.append(body)
		print(body)
		print("Lewa mutacja kandydat wszedł")


func _on_left_skillzone_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		mut_cand_left.erase(body)
		print(body)
		print("Lewa mutacja kandydat wyszedł")
