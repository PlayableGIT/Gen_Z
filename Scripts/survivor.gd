extends CharacterBody2D

var zombie_in_range = false
var zombie_attack_cooldown = true
var health = 25
var survivor_alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("survivor")
	$Label.visible = false
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
	

func survivor():
	pass
	
func zombie_attack():
	if zombie_in_range and zombie_attack_cooldown:
			#rng
		var rng_damage = StatsAutoload.zombie_damage
		zombie_attack_cooldown = false
		$attack_cooldown.start()
		health = health - rng_damage
		$Survivor01.animation = "hurt"
		print("Survivor took ", StatsAutoload.zombie_damage, " damage! Health: ", health)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = true
		$Label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false
		$Survivor01.animation = "default"


func _on_attack_cooldown_timeout() -> void:
	zombie_attack_cooldown = true
	$Label.visible = false
