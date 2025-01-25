extends CharacterBody2D


@export var Bullet : PackedScene
var zombie_in_range = false
var zombie_attack_cooldown = true
var health = 30
var survivor_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("survivor")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false


func _on_attack_cooldown_timeout() -> void:
	zombie_attack_cooldown = true


func _on_gun_range_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		#zombie_in_range = true
		$survivor_gun.animation = "shoot"


func _on_gun_range_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		#zombie_in_range = false
		$survivor_gun.animation = "idle"



func _on_survivor_gun_animation_looped() -> void:
	if $survivor_gun.animation == "idle":
		pass
	else:
		shoot()

func _on_survivor_gun_animation_changed() -> void:
	if $survivor_gun.animation == "idle":
		pass
	else:
		shoot()
