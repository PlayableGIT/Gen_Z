extends Node2D

var zombieDamageAmount: int
signal door_boom(a: Vector2)
signal zombie_spawn(a: Vector2)
signal zombie_runner_spawn(a: Vector2)
signal zombie_tank_spawn(a: Vector2)
signal zombie_death(a: Vector2)
signal zombie_tank_death(a: Vector2)
signal survivor_death(a: Vector2)
signal level_complete
@export var ui: PackedScene
@export var destroyed_door: PackedScene
@export var dead_survivor: PackedScene
@export var dead_zombie: PackedScene
@export var dead_gun_survivor: PackedScene
@export var zombie: PackedScene
@export var cheerleader_zombie: PackedScene
@export var tank_zombie: PackedScene
@export var runner_zombie: PackedScene
@export var survivor: PackedScene
@onready var pause_menu: = $CanvasLayer/PauseMenu
var paused = false
var nekro_stat = StatsAutoload.nekroplazma
var nekro_cost = 0
var zombie_count = 0
var zombie_respawn = true
var level_accomp = false
var level_fade = false
var mouse_lock = false
var zombie_1 = false
var zombie_2 = false
var zombie_3 = false
var zombie_4 = false
var mutation_array: Array[Node2D] = []
var rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$respawn_bar.value = 0
	$respawn_bar.visible = false
	var string = "Nekroplazma: " + str(nekro_stat)
	$Camera2D/HUD/stats_cont/stats.text = string
	$Camera2D/HUD/LC_cont/level_complete.modulate.a = 0
	$Ambient.play()
	door_boom.connect(door_destro)
	zombie_spawn.connect(zombie_spawn_sound)
	zombie_runner_spawn.connect(zombie_runner_spawn_sound)
	zombie_tank_spawn.connect(zombie_tank_spawn_sound)
	zombie_death.connect(zomb_death)
	zombie_tank_death.connect(zomb_tank_death)
	survivor_death.connect(surv_death)
	level_complete.connect(level_comp)
	await get_tree().create_timer(2.0).timeout
	lightning()
func _process(delta):
	var mutation_array = get_tree().get_nodes_in_group("mutation")
	#print(get_tree().get_nodes_in_group("mutation"))
	if mutation_array.size() == 2:
		for node in mutation_array:
			var global_pos = node.global_position
			print(global_pos)
		var mut1 = mutation_array[0]
		var mut2 = mutation_array[1]
		var pos1 = mut1.global_position.x
		var pos2 = mut2.global_position.x
		var glo_pos1 = mut1.global_position
		print(pos1, pos2)
		var closer_pos = 0
		var furt_pos = 0
		if pos1 > pos2:
			closer_pos = pos1
			furt_pos = pos2
		if pos2 > pos1:
			closer_pos = pos2
			furt_pos = pos1
		var dist_mut = furt_pos - closer_pos
		var dist_mut_abs = abs(dist_mut)
		print(dist_mut_abs)
		if dist_mut_abs <= 300:
			mut1.queue_free()
			mut2.queue_free()
			var new_zombie = tank_zombie.instantiate()
			new_zombie.position = glo_pos1 + Vector2(50, 0)
			add_child(new_zombie)
			zombie_spawn.emit(new_zombie.global_position)
			print("MUTTTACJA")
		if dist_mut_abs >= 300:
			print("ZA DALEKO KRUWA")
	
	if $Camera2D.is_in_group("mouse_lock"):
		mouse_lock = true
	if $Camera2D.is_in_group("mouse_lock") != true:
		mouse_lock = false
	
	if $Camera2D.is_in_group("casual_zombie"):
		#print("Casual Zombie, Necroplasm Cost: 2")
		nekro_cost = 2
		await get_tree().create_timer(0.1).timeout
		zombie_1 = true
		zombie_2 = false
		zombie_3 = false
		zombie_4 = false
	if $Camera2D.is_in_group("casual_zombie") != true:
		zombie_1 = false
	if $Camera2D.is_in_group("cheerleader_zombie"):
		#print("Casual Zombie, Necroplasm Cost: 2")
		nekro_cost = 2
		await get_tree().create_timer(0.1).timeout
		zombie_1 = false
		zombie_2 = true
		zombie_3 = false
		zombie_4 = false
	if $Camera2D.is_in_group("cheerleader_zombie") != true:
		zombie_2 = false
		
	$respawn_bar.global_position = get_global_mouse_position()
	var czas = $zombie_respawn2.wait_time - $zombie_respawn2.time_left
	$respawn_bar.value = czas
	var string1 = "Nekroplazma: " + str(nekro_stat)
	$Camera2D/HUD/stats_cont/stats.text = string1
	if level_fade == true:
		$Camera2D/HUD/LC_cont/level_complete.modulate.a += 1 * delta
		if $Camera2D/HUD/LC_cont/level_complete.modulate.a >= 1:
			level_fade = false
	var survivors = get_tree().get_nodes_in_group("survivor")
	var gun_survivors = get_tree().get_nodes_in_group("survivor_gun")
	if Input.is_action_just_released("0"):
		print("No zombie selected.")
		zombie_1 = false
		zombie_2 = false
		zombie_3 = false
		zombie_4 = false
	if Input.is_action_just_released("3"):
		print("Runner Zombie, Necroplasm Cost: 4")
		nekro_cost = 4
		zombie_1 = false
		zombie_2 = false
		zombie_3 = true
		zombie_4 = false
	if Input.is_action_just_released("4"):
		print("Tank Zombie, Necroplasm Cost: 8")
		nekro_cost = 8
		zombie_1 = false
		zombie_2 = false
		zombie_3 = false
		zombie_4 = true
	
	if survivors.size() == 0 and gun_survivors.size() == 0 and level_accomp == false:
		level_complete.emit()
		level_accomp = true
	
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat >= nekro_cost and zombie_1 == true:
		$zombie_respawn2.start()
		$respawn_bar.visible = true
		zombie_count += 1
		nekro_stat -= 2
		var string = "Nekroplazma: " + str(nekro_stat)
		$Camera2D/HUD/stats_cont/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = zombie.instantiate()
		new_zombie.position = get_global_mouse_position()
		add_child(new_zombie)
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat >= nekro_cost and zombie_2 == true:
		zombie_count += 1
		nekro_stat -= 4
		var string = "Nekroplazma: " + str(nekro_stat)
		$Camera2D/HUD/stats_cont/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = cheerleader_zombie.instantiate()
		new_zombie.position = get_global_mouse_position()
		add_child(new_zombie)
		zombie_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat >= nekro_cost and zombie_3 == true:
		zombie_count += 1
		nekro_stat -= 4
		var string = "Nekroplazma: " + str(nekro_stat)
		$Camera2D/HUD/stats_cont/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = runner_zombie.instantiate()
		new_zombie.position = get_global_mouse_position()
		add_child(new_zombie)
		zombie_runner_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat >= nekro_cost and zombie_4 == true:
		zombie_count += 1
		nekro_stat -= 8
		var string = "Nekroplazma: " + str(nekro_stat)
		$Camera2D/HUD/stats_cont/stats.text = string
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = tank_zombie.instantiate()
		new_zombie.position = get_global_mouse_position()
		add_child(new_zombie)
		zombie_tank_spawn.emit(new_zombie.global_position)
		$Zombie_Spawn.play()
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true and mouse_lock == false and nekro_stat < nekro_cost and (zombie_1 == true or zombie_2 == true or zombie_3 == true or zombie_4 == true):
		print("Insufficient Necroplasm!")
	if Input.is_action_just_released("right_mouse"):
		print("No zombie selected.")
		$Camera2D.remove_from_group("casual_zombie")
		$Camera2D.remove_from_group("cheerleader_zombie")
		zombie_1 = false
		zombie_2 = false
		zombie_3 = false
		zombie_4 = false
		#var new_survivor = survivor.instantiate()
		#new_survivor.position = get_global_mouse_position()
		#add_child(new_survivor)

	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		

func zombie_spawn_sound(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Spawn2.global_position = sound_position
	$Zombie_Spawn2.pitch_scale = rng_pitch_number
	$Zombie_Spawn2.play()

func zombie_runner_spawn_sound(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Runner_Spawn.global_position = sound_position
	$Zombie_Runner_Spawn.pitch_scale = rng_pitch_number
	$Zombie_Runner_Spawn.play()

func zombie_tank_spawn_sound(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Tank_Spawn.global_position = sound_position
	$Zombie_Tank_Spawn.pitch_scale = rng_pitch_number
	$Zombie_Tank_Spawn.play()

func surv_death(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	if $Survivor_Death != null:
		$Survivor_Death.global_position = sound_position
		$Survivor_Death.pitch_scale = rng_pitch_number
		$Survivor_Death.play()

func door_destro(a):
	var sound_position = Vector2(a)
	if $Door_Destro != null:
		$Door_Destro.global_position = sound_position
		$Door_Destro.play()
	
func zomb_death(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Death.pitch_scale = rng_pitch_number
	$Zombie_Death.global_position = sound_position
	$Zombie_Death.play()

func zomb_tank_death(a):
	var rng_pitch_number = rng.randf_range(0.8, 1.1)
	var sound_position = Vector2(a)
	$Zombie_Tank_Death.pitch_scale = rng_pitch_number
	$Zombie_Tank_Death.global_position = sound_position
	$Zombie_Tank_Death.play()
	
func lightning():
	$lightning_timer.wait_time = rng.randf_range(10.0, 20.0)
	$lightning_timer.start()
	$Node/DirectionalLight2D.energy = 0.2
	$lightning.play()
	await get_tree().create_timer(0.229).timeout
	$Node/DirectionalLight2D.energy = 0.4
	await get_tree().create_timer(0.1).timeout
	$Node/DirectionalLight2D.energy = 0.25
	await get_tree().create_timer(0.229).timeout
	$Node/DirectionalLight2D.energy = 0.97
	
func _on_child_exiting_tree(node: Node) -> void:
	var rng_x = rng.randf_range(-50.0, 50.0)
	var rng_dead_spawn = Vector2(rng_x, 0)
	if node.has_method("zombie"):
		if node.has_method("tank"):
			zombie_count -=1
			print(zombie_count)
			var death_zombie = dead_zombie.instantiate()
			add_child.call_deferred(death_zombie)
			death_zombie.position = node.position + rng_dead_spawn
			zombie_tank_death.emit(node.global_position)
			#print("usunieto zombie")
		else:
			if node.is_in_group("left"):
				zombie_count -=1
				print(zombie_count)
				var death_zombie = dead_zombie.instantiate()
				add_child.call_deferred(death_zombie)
				death_zombie.position = node.position + rng_dead_spawn
				death_zombie.flip_h = true
				zombie_death.emit(node.global_position)
			elif node.is_in_group("right"):
				zombie_count -=1
				print(zombie_count)
				var death_zombie = dead_zombie.instantiate()
				add_child.call_deferred(death_zombie)
				death_zombie.position = node.position + rng_dead_spawn
				death_zombie.flip_h = false
				zombie_death.emit(node.global_position)
	if node.has_method("survivor"):
		if node.is_in_group("left"):
			survivor_death.emit(node.global_position)
			var death_survivor = dead_survivor.instantiate()
			add_child.call_deferred(death_survivor)
			death_survivor.position = node.position + rng_dead_spawn
			death_survivor.flip_h = true
		elif node.is_in_group("right"):
			survivor_death.emit(node.global_position)
			var death_survivor = dead_survivor.instantiate()
			add_child.call_deferred(death_survivor)
			death_survivor.position = node.position + rng_dead_spawn
			death_survivor.flip_h = false
	if node.has_method("door"):
		door_boom.emit(node.global_position)
		print("skibidibi")
		var destroy_door = destroyed_door.instantiate()
		add_child.call_deferred(destroy_door)
		destroy_door.position = node.position
	
	if node.has_method("survivor_gun"):
		survivor_death.emit(node.global_position)
		print("labadaba")
		var destroy_survivor_gun = dead_gun_survivor.instantiate()
		add_child.call_deferred(destroy_survivor_gun)
		destroy_survivor_gun.position = node.position

func level_comp():
	$Camera2D/HUD/LC_cont/level_complete.visible = true
	level_fade = true
	$Camera2D/HUD/level_complete_sound.play()
	print("level comp")

func get_node_global_position(index: int) -> Vector2:
	if index >= 0 and index < mutation_array.size():
		return mutation_array[index].global_position
	else:
		return Vector2.ZERO


func _on_ambient_finished() -> void:
	$Ambient.play()


func _on_zombie_respawn_timeout() -> void:
	zombie_respawn = true


func _on_spawn_restriction_mouse_entered() -> void:
	$Camera2D.add_to_group("mouse_lock")
	mouse_lock = true


func _on_spawn_restriction_mouse_exited() -> void:
	$Camera2D.remove_from_group("mouse_lock")
	mouse_lock = false


func _on_child_entered_tree(node: Node) -> void:
	if node.has_method("necroplasm"):
		nekro_stat += 5
		print("5 Necroplasm collected!")


func _on_zombie_respawn_2_timeout() -> void:
	$respawn_bar.visible = false


func _on_lightning_timer_timeout() -> void:
	lightning()


func pauseMenu():
	if paused: 
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
