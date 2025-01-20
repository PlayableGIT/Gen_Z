extends Node2D

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
