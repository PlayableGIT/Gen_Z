extends CharacterBody2D

@export var dead_zombie: PackedScene
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

func _ready() -> void:
	var total_dice_sides = 7
	$Zombie03.frame = randi() % total_dice_sides

func _physics_process(delta: float) -> void:
	#grawitacja
	if not is_on_floor():
		velocity += get_gravity() * 50 * delta
		velocity.x = 0.0
		move_and_slide()
		
	var player = get_parent().find_child("Survivor")
	if player == null:
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
	#powolanie survivora
	var player = get_parent().find_child("Survivor")
	#kierunek
	direction = global_position.direction_to(player.global_position)
	
	#predkosc w kierunku
	velocity = direction.normalized() * speed
	if direction.normalized() <= Vector2(0, -0.2):
		$Zombie03.set_flip_h(true)
	#print(direction.normalized())

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
		var rng = RandomNumberGenerator.new()
		var rng_damage = rng.randi_range(1, 10)	
		survivor_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		print("Zombie took ", rng_damage, " damage! Health: ", health)
		
	if survivor_in_gun_range and survivor_attack_cooldown:
			#rng
		var rng = RandomNumberGenerator.new()
		var rng_damage = rng.randi_range(5, 15)	
		survivor_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		print("Zombie took ", rng_damage, " damage! Health: ", health)


func _on_attack_cooldown_timeout() -> void:
	survivor_attack_cooldown = true


func _on_gun_area_body_entered(body: Node2D) -> void:
	if body.has_method("survivor_gun"):
		survivor_in_gun_range = true


func _on_gun_area_body_exited(body: Node2D) -> void:
	if body.has_method("survivor_gun"):
		survivor_in_gun_range = false
