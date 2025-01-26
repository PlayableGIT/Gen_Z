extends CharacterBody2D

var direction = Vector2.ZERO
@export var Bullet : PackedScene
@export var Bullet_left: PackedScene
var zombie_in_range = false
var zombie_in_gun_range = false
var zombie_attack_cooldown = true
var health = 30
var survivor_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("survivor")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var close_zomb = get_closest_player_or_null()
	get_closest_player_or_null()
	if bodies_inside.size()==0:
		$survivor_gun.animation = "idle"
	
	if bodies_inside_melee.size() == 0 and bodies_inside.size() > 0:
		var kierunek = close_zomb.position - $".".position
		if kierunek >= Vector2(0,0):
			print("prawo")
			$survivor_gun.set_flip_h(false)
			$Marker2D.position = Vector2(150,0)
			$survivor_gun.animation = "shoot"
		elif kierunek <=Vector2(0,0):
			$survivor_gun.set_flip_h(true)
			$Marker2D.position = Vector2(-150,0)
			$survivor_gun.animation = "shoot"
	else:
		pass
		
	get_closest_player_or_null()
	
	if not is_on_floor():
		velocity += get_gravity() * 10 * delta
		velocity.x = 0.0
	move_and_slide()
	zombie_attack()
	if health <= 0:
		survivor_alive = false
		health = 0
		print("Survivor has been killed!")
		self.queue_free()
	
func shoot():
	var b = Bullet.instantiate()
	call_deferred("add_child", b)
	b.transform = $Marker2D.transform
	
func shoot_left():
	var b = Bullet_left.instantiate()
	call_deferred("add_child", b)
	b.transform = $Marker2D.transform

func survivor_gun():
	pass
	
func zombie_attack():
	if zombie_in_range and zombie_attack_cooldown:
			#rng
		var rng_damage = StatsAutoload.zombie_damage
		zombie_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		print("Survivor took ", rng_damage, " damage! Health: ", health)

func get_closest_player_or_null():
	var all_players = get_tree().get_nodes_in_group("zombie")
	var closest_player = null
	
	if(all_players.size()>0):
		closest_player = all_players[0]
		for player in all_players:
			var distance_to_this_player = global_position.distance_squared_to(player.global_position)
			var distance_to_closest_player = global_position.distance_squared_to(closest_player.global_position)
			if (distance_to_this_player < distance_to_closest_player):
				closest_player = player
				#print(closest_player)
	return closest_player

var bodies_inside: = []
var bodies_inside_melee: = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = true
		bodies_inside_melee.append(body)
	if body.has_method("zombie") and bodies_inside_melee.size() >= 0:
		#zombie_in_range = true
		var kierunek = body.position - $".".position
		if kierunek >= Vector2(0,0):
			print("prawo")
			$survivor_gun.set_flip_h(false)
			$Marker2D.position = Vector2(150,0)
			$survivor_gun.animation = "shoot"
		elif kierunek <=Vector2(0,0):
			$survivor_gun.set_flip_h(true)
			$Marker2D.position = Vector2(-150,0)
			$survivor_gun.animation = "shoot"
	else:
		pass
	if body.has_method("zombie") and bodies_inside_melee.size() == 0:
		$survivor_gun.animation = "idle"
	print("Melee: ", bodies_inside_melee.size())


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false
		bodies_inside_melee.erase(body)
	if body.has_method("zombie") and bodies_inside_melee.size() <= 0:
		$survivor_gun.animation = "idle"
	print("Melee: ", bodies_inside_melee.size())


func _on_attack_cooldown_timeout() -> void:
	zombie_attack_cooldown = true



func _on_gun_range_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		bodies_inside.append(body)
	if body.has_method("zombie") and bodies_inside.size() >= 0:
		zombie_in_gun_range = true
		var kierunek = body.position - $".".position
		if kierunek >= Vector2(0,0):
			print("prawo")
			$survivor_gun.set_flip_h(false)
			$Marker2D.position = Vector2(150,0)
			$survivor_gun.animation = "shoot"
		elif kierunek <=Vector2(0,0):
			$survivor_gun.set_flip_h(true)
			$Marker2D.position = Vector2(-150,0)
			$survivor_gun.animation = "shoot"
		#$survivor_gun.animation = "shoot"
		print(bodies_inside.size())
		print(kierunek.normalized())
	else:
		pass
	print(bodies_inside.size())

func _on_gun_range_body_exited(body: Node2D) -> void:
	#bodies_inside.erase(body)
	if body.has_method("zombie"):
		bodies_inside.erase(body)
	if body.has_method("zombie") and bodies_inside.size() == 0:
		zombie_in_gun_range = false
		$survivor_gun.animation = "idle"
	elif body.has_method("zombie") and bodies_inside.size() > 0:
		pass
	print(bodies_inside.size())



func _on_survivor_gun_animation_looped() -> void:
	if $survivor_gun.animation == "idle":
		pass
	elif $survivor_gun.flip_h == true:
		shoot_left()
	elif $survivor_gun.flip_h == false:
		shoot()

func _on_survivor_gun_animation_changed() -> void:
	if $survivor_gun.animation == "idle":
		pass
	elif $survivor_gun.flip_h == true:
		shoot_left()
	elif $survivor_gun.flip_h == false:
		shoot()
