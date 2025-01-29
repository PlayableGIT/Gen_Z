extends StaticBody2D

var zombie_in_range = false
var zombie_attack_cooldown = true
var health = 25
var door_not_destroyed = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CPUParticles2D.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	zombie_attack()
	if health <= 0:
		door_not_destroyed = false
		health = 0
		$CPUParticles2D.visible = false
		print("Door has been destroyed!")
		self.queue_free()

func door():
	pass



func zombie_attack():
	if zombie_in_range and zombie_attack_cooldown:
			#rng
		var rng = RandomNumberGenerator.new()
		var rng_damage = rng.randi_range(1, 10)	
		zombie_attack_cooldown = false
		$door_attack_cooldown.start()
		health = health - rng_damage
		$CPUParticles2D.visible = true
		$door_hit.play()
		print("Door took ", rng_damage, " damage! Health: ", health)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false
		$CPUParticles2D.visible = false


func _on_timer_timeout() -> void:
	zombie_attack_cooldown = true
