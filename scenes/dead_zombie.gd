extends AnimatedSprite2D

var necroplasm_collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_on_necroplasm_area_mouse_entered()


func _on_necroplasm_area_mouse_entered() -> void:
	if Input.is_action_just_released("left_mouse"):
		if $necroplasm != null and necroplasm_collected == false:
			var new_node = preload("res://necroplasm.tscn").instantiate()
			get_tree().current_scene.add_child(new_node)
			necroplasm_collected = true
		else:
			pass
