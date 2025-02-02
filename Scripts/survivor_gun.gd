extends CharacterBody2D

var direction = Vector2.ZERO
@onready var Survivor: PackedScene
@export var Bullet : PackedScene
@export var Bullet_left: PackedScene
var zombie_in_range = false
var zombie_attack_cooldown = true
var health = 30
var survivor_alive = true
var uwaga_drzwi = null
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	set_Health_bar()
	$Label.visible = false
	add_to_group("survivor")

func _physics_process(delta: float) -> void:
	rayCastException()
	zombie_attack()
	var close_zomb = get_closest_player_or_null()
	$RayCast2D.enabled = true
	if close_zomb != null:
		var angle_to: float = global_position.direction_to(close_zomb.global_position).angle()
		
		$RayCast2D.global_rotation = angle_to
		var kat = rad_to_deg(angle_to)
		print(kat)
	
	if $RayCast2D.is_colliding() == null:
		pass
	if $RayCast2D.is_colliding() == true:
		var first_hit = $RayCast2D.get_collider()
		if first_hit != null:
			if first_hit.has_method("door"):
				uwaga_drzwi = true 
			elif first_hit.has_method("ground"):
				uwaga_drzwi = true
			else:
				uwaga_drzwi = false 
	
	
	if uwaga_drzwi == false and close_zomb != null and $RayCast2D.is_colliding() == true:
		var angle_to: float = global_position.direction_to(close_zomb.global_position).angle()
		var kat = rad_to_deg(angle_to)
		if kat <= 180 and kat >= -180:
			$survivor_gun.set_flip_h(false)
			$survivor_gun.position = Vector2(50,0)
			$RayCast2D.position = Vector2(150,0)
			$survivor_gun.animation = "shoot"
		elif angle_to >= -180 and angle_to <= 180.0:
			$survivor_gun.set_flip_h(true)
			$survivor_gun.position = Vector2(-50,0)
			$RayCast2D.position = Vector2(-140,0)
			$survivor_gun.animation = "shoot"
		else:
			$survivor_gun.animation = "idle"
	else:
		$survivor_gun.animation = "idle"
		
	if not is_on_floor():
		velocity += get_gravity() * 10 * delta
		velocity.x = 0.0
	move_and_slide()
	if health <= 0:
		survivor_alive = false
		health = 0
		print("Survivor has been killed!")
		self.queue_free()

func shoot():
	var b = Bullet.instantiate()
	call_deferred("add_child", b)
	b.transform = $RayCast2D.transform
	$gunshot.play()
	
func shoot_left():
	var b = Bullet.instantiate()
	call_deferred("add_child", b)
	b.transform = $RayCast2D.transform
	$gunshot.play()

func blood_splatter():
	var splat_x = rng.randf_range(-50.0, 50.0)
	var splat_y = rng.randf_range(-50.0, 50.0)
	var splatter_position = Vector2(splat_x, splat_y)
	$blood_splatter.position = splatter_position
	$blood_splatter.visible = true
	$blood_splatter.one_shot = true
	$blood_splatter.emitting = true

func survivor_gun():
	pass

var teksty: = ["NEED BACKUP!", "THIS IS NOTHING LIKE THE SIMULATIONS!","", "ENEMY CLOSE!"]
var x = 0

func zombie_attack():
	if zombie_in_range and zombie_attack_cooldown:
		var rng_damage = StatsAutoload.zombie_damage
		zombie_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		$Label.text = teksty[x]
		$Label.visible = true
		blood_splatter()
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
	return closest_player

func _on_attack_cooldown_timeout() -> void:
	zombie_attack_cooldown = true
	x += 1
	$Label.visible = false

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

func rayCastException() -> void:
	var survivor = get_tree().get_nodes_in_group("survivor")
	for i in survivor:
		$RayCast2D.add_exception(i)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if x >= 1:
		x=-1
	if body.has_method("zombie"):
		zombie_in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false
		
func set_Health_bar():
	$HealthBar.value = health
