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
@export var survivor: PackedScene
var zombie_respawn = true
var level_accomp = false
var level_fade = false

var rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$Camera2D/level_complete.modulate.a = 0
	$Ambient.play()
	door_boom.connect(door_destro)
	zombie_spawn.connect(zombie_spawn_sound)
	zombie_death.connect(zomb_death)
	survivor_death.connect(surv_death)
	level_complete.connect(level_comp)
func _process(delta):
	
	if level_fade == true:
		$Camera2D/level_complete.modulate.a += 1 * delta
		if $Camera2D/level_complete.modulate.a == 1:
			level_fade = false
	var survivors = get_tree().get_nodes_in_group("survivor")
	var gun_survivors = get_tree().get_nodes_in_group("survivor_gun")
	
	if survivors.size() == 0 and gun_survivors.size() == 0 and level_accomp == false:
		level_complete.emit()
		level_accomp = true
	
	if Input.is_action_just_released("left_mouse") and zombie_respawn == true:
		zombie_respawn = false
		$zombie_respawn.start()
		var new_zombie = zombie.instantiate()
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
		var death_zombie = dead_zombie.instantiate()
		add_child.call_deferred(death_zombie)
		death_zombie.position = node.position
		zombie_death.emit(node.global_position)
	
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
