extends Node2D

var zombieDamageAmount: int
signal door_boom(a: Vector2)
signal zombie_spawn(a: Vector2)
signal zombie_death(a: Vector2)
signal survivor_death(a: Vector2)
signal level_complete
@export var destroyed_door: PackedScene
@export var dead_survivor: PackedScene
@export var dead_zombie: PackedScene
@export var dead_gun_survivor: PackedScene
@export var zombie: PackedScene
@export var cheerleader_zombie: PackedScene
@export var tank_zombie: PackedScene
@export var runner_zombie: PackedScene
@export var survivor: PackedScene
var nekro_stat = StatsAutoload.nekroplazma
var zombie_count = 0
var zombie_respawn = true
var level_accomp = false
var level_fade = false
var mouse_lock = false
var zombie_1 = false
var zombie_2 = false
var zombie_3 = false
var zombie_4 = false

var rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	var string = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
	$Camera2D/stats.text = string
	$Camera2D/level_complete.modulate.a = 0
	$Ambient.play()
	door_boom.connect(door_destro)
	zombie_spawn.connect(zombie_spawn_sound)
	zombie_death.connect(zomb_death)
	survivor_death.connect(surv_death)
	level_complete.connect(level_comp)
func _process(delta):
	var string1 = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
	$Camera2D/stats.text = string1
	if level_fade == true:
		$Camera2D/level_complete.modulate.a += 1 * delta
		if $Camera2D/level_complete.modulate.a == 1:
			level_fade = false
	var survivors = get_tree().get_nodes_in_group("survivor")
	var gun_survivors = get_tree().get_nodes_in_group("survivor_gun")
	
	if Input.is_action_just_released("1"):
		print("zombie1")
		zombie_1 = true
		zombie_2 = false
		zombie_3 = false
		zombie_4 = false
	if Input.is_action_just_released("2"):
		print("zombie2")
		zombie_1 = false
		zombie_2 = true
		zombie_3 = false
		zombie_4 = false
	if Input.is_action_just_released("3"):
		print("zombie3")
		zombie_1 = false
		zombie_2 = false
		zombie_3 = true
		zombie_4 = false
	if Input.is_action_just_released("4"):
		print("zombie4")
		zombie_1 = false
		zombie_2 = false
		zombie_3 = false
		zombie_4 = true
	
	if survivors.size() == 0 and gun_survivors.size() == 0 and level_accomp == false:
		level_complete.emit()
		level_accomp = true
	
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat > 1 and zombie_1 == true:
		zombie_count += 1
		nekro_stat -= 2
		var string = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
		$Camera2D/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = zombie.instantiate()
		add_child(new_zombie)
		new_zombie.position = get_global_mouse_position()
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat > 1 and zombie_2 == true:
		zombie_count += 1
		nekro_stat -= 4
		var string = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
		$Camera2D/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = cheerleader_zombie.instantiate()
		add_child(new_zombie)
		new_zombie.position = get_global_mouse_position()
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat > 1 and zombie_3 == true:
		zombie_count += 1
		nekro_stat -= 4
		var string = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
		$Camera2D/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = runner_zombie.instantiate()
		add_child(new_zombie)
		new_zombie.position = get_global_mouse_position()
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat > 1 and zombie_4 == true:
		zombie_count += 1
		nekro_stat -= 8
		var string = "Nekroplazma: " + str(nekro_stat) + "   Zombies: " + str(zombie_count)
		$Camera2D/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = tank_zombie.instantiate()
		add_child(new_zombie)
		new_zombie.position = get_global_mouse_position()
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("right_mouse"):
		var new_survivor = survivor.instantiate()
		add_child(new_survivor)
		new_survivor.position = get_global_mouse_position()

func zombie_spawn_sound(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Spawn2.global_position = sound_position
	$Zombie_Spawn2.pitch_scale = rng_pitch_number
	$Zombie_Spawn2.play()
	
func surv_death(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Survivor_Death.global_position = sound_position
	$Survivor_Death.pitch_scale = rng_pitch_number
	$Survivor_Death.play()

func door_destro(a):
	var sound_position = Vector2(a)
	$Door_Destro.global_position = sound_position
	$Door_Destro.play()
	
func zomb_death(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Death.pitch_scale = rng_pitch_number
	$Zombie_Death.global_position = sound_position
	$Zombie_Death.play()

func _on_child_exiting_tree(node: Node) -> void:
	if node.has_method("zombie"):
		zombie_count -=1
		print(zombie_count)
		var death_zombie = dead_zombie.instantiate()
		add_child.call_deferred(death_zombie)
		death_zombie.position = node.position
		zombie_death.emit(node.global_position)
		print("usunieto zombie")
	
	if node.has_method("survivor"):
		var death_survivor = dead_survivor.instantiate()
		add_child.call_deferred(death_survivor)
		death_survivor.position = node.position
		survivor_death.emit(node.global_position)
		
	if node.has_method("door"):
		var destroy_door = destroyed_door.instantiate()
		add_child.call_deferred(destroy_door)
		destroy_door.position = node.position
		door_boom.emit(node.global_position)
	
	if node.has_method("survivor_gun"):
		var destroy_survivor_gun = dead_gun_survivor.instantiate()
		add_child.call_deferred(destroy_survivor_gun)
		destroy_survivor_gun.position = node.position
		survivor_death.emit(node.global_position)


func level_comp():
	$Camera2D/level_complete.visible = true
	level_fade = true
	$Camera2D/level_complete_sound.play()
	print("level comp")

func _on_ambient_finished() -> void:
	$Ambient.play()


func _on_zombie_respawn_timeout() -> void:
	zombie_respawn = true


func _on_spawn_restriction_mouse_entered() -> void:
	mouse_lock = true


func _on_spawn_restriction_mouse_exited() -> void:
	mouse_lock = false
