extends Node2D

var zombieDamageAmount: int
signal door_boom(a: Vector2)
signal zombie_spawn(a: Vector2)
signal zombie_death(a: Vector2)
@export var destroyed_door: PackedScene
@export var dead_survivor: PackedScene
@export var dead_zombie: PackedScene
@export var dead_gun_survivor: PackedScene
@export var zombie: PackedScene
@export var survivor: PackedScene

var rng = RandomNumberGenerator.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	
	$Ambient.play()
	door_boom.connect(door_destro)
	zombie_spawn.connect(zombie_spawn_sound)
	zombie_death.connect(zomb_death)
func _process(_delta):
	if Input.is_action_just_released("left_mouse"):
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
		
	if node.has_method("door"):
		var destroy_door = destroyed_door.instantiate()
		add_child.call_deferred(destroy_door)
		destroy_door.position = node.position
		door_boom.emit(node.global_position)
	
	if node.has_method("survivor_gun"):
		var destroy_survivor_gun = dead_gun_survivor.instantiate()
		add_child.call_deferred(destroy_survivor_gun)
		destroy_survivor_gun.position = node.position


func _on_ambient_finished() -> void:
	$Ambient.play()
