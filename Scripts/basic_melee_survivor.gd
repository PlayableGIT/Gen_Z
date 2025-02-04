extends CharacterBody2D

var zombie_in_range = false
var zombie_attack_cooldown = true
var health = 25
var survivor_alive = true
var can_move = false
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("survivor")
	$Label.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var rng_move_seed = rng.randf_range(0.0, 10.0)
	
	if $Survivor_Sprite.flip_h == true:
		add_to_group("left")
		remove_from_group("right")
	if $Survivor_Sprite.flip_h == false:
		add_to_group("right")
		remove_from_group("left")
	
	
	#print(rng_move_seed)
	if not is_on_floor():
		velocity += get_gravity() * 10 * delta
		velocity.x = 0.0
		
	if rng_move_seed >= 9.5 and rng_move_seed <= 10.0 and can_move==false and zombie_in_range == false:
		can_move = true
		$move_timer.start()
		move_right()
	elif rng_move_seed >= 0.0 and rng_move_seed <= 0.5 and can_move==false and zombie_in_range == false:
		can_move = true
		$move_timer.start()
		move_left()
	else:
		velocity.x = 0
		
	move_and_slide()
	zombie_attack()
	if health <= 0:
		survivor_alive = false
		health = 0
		print("Survivor has been killed!")
		self.queue_free()
	set_Health_bar()

func move_left():
	velocity.x = 5000
	$Survivor_Sprite.flip_h = false

func move_right():
	velocity.x = -5000
	$Survivor_Sprite.flip_h = true

func survivor():
	pass
	
func zombie_attack():
	if zombie_in_range and zombie_attack_cooldown:
			#rng
		$Survivor_Sprite.animation = "attack"
		var rng_damage = StatsAutoload.zombie_damage
		zombie_attack_cooldown = false
		$survivor_attack.play()
		health = health - rng_damage
		$attack_cooldown.start()
		blood_splatter()
		print("Survivor took ", StatsAutoload.zombie_damage, " damage! Health: ", health)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if x >= 2:
		x=-1
	if body.has_method("zombie"):
		zombie_in_range = true
		$Label.text = teksty[x]
		var rng_pitch_number = rng.randf_range(0.5, 1.3)
		$text_popup.pitch_scale = rng_pitch_number
		$text_popup.play()
		$Label.visible = true
		if body.position.x >= $".".position.x:
			$Survivor_Sprite.flip_h = false
		if body.position.x <= $".".position.x:
			$Survivor_Sprite.flip_h = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("zombie"):
		zombie_in_range = false
		$Survivor_Sprite.animation = "idle"

var teksty: = ["EAT SHIT!!!","", "DIE! DIE! DIE!","","", "MOTHERFU-"]
var x = 0
func _on_attack_cooldown_timeout() -> void:
	zombie_attack_cooldown = true
	x += 1
	$Label.visible = false


func blood_splatter():
	var splat_x = rng.randf_range(-50.0, 50.0)
	var splat_y = rng.randf_range(-50.0, 50.0)
	var splatter_position = Vector2(splat_x, splat_y)
	$blood_splatter.position = splatter_position
	$blood_splatter.visible = true
	$blood_splatter.one_shot = true
	$blood_splatter.emitting = true

func _on_survivor_01_animation_looped() -> void:
	if $Survivor_Sprite.animation == "attack":
		blood_splatter()


func _on_survivor_01_animation_changed() -> void:
	if $Survivor_Sprite.animation == "attack":
		blood_splatter()

func set_Health_bar() -> void:
	$HealthBar.value = health


func _on_move_timer_timeout() -> void:
	can_move = false
