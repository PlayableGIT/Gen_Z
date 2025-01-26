extends Node2D

var zombieDamageAmount: int

@export var destroyed_door: PackedScene
@export var dead_survivor: PackedScene
@export var dead_zombie: PackedScene
@export var dead_gun_survivor: PackedScene
@export var zombie: PackedScene
@export var survivor: PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("left_mouse"):
		var new_zombie = zombie.instantiate()
		add_child(new_zombie)
		new_zombie.position = get_global_mouse_position()
	if Input.is_action_just_released("right_mouse"):
		var new_survivor = survivor.instantiate()
		add_child(new_survivor)
		new_survivor.position = get_global_mouse_position()






func _on_child_exiting_tree(node: Node) -> void:
	if node.has_method("zombie"):
		var death_zombie = dead_zombie.instantiate()
		add_child.call_deferred(death_zombie)
		death_zombie.position = node.position
		
	if node.has_method("survivor"):
		var death_survivor = dead_survivor.instantiate()
		add_child.call_deferred(death_survivor)
		death_survivor.position = node.position
		
	if node.has_method("door"):
		var destroy_door = destroyed_door.instantiate()
		add_child.call_deferred(destroy_door)
		destroy_door.position = node.position
	
	if node.has_method("survivor_gun"):
		var destroy_survivor_gun = dead_gun_survivor.instantiate()
		add_child.call_deferred(destroy_survivor_gun)
		destroy_survivor_gun.position = node.position
