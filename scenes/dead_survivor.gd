extends AnimatedSprite2D
var can_collect = false
var necroplasm_collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_on_necroplasm_area_mouse_entered()


func _on_necroplasm_area_mouse_entered() -> void:
	if Input.is_action_just_released("left_mouse"):
		if necroplasm_collected == false and can_collect == true:
			var new_node = preload("res://necroplasm.tscn").instantiate()
			get_tree().current_scene.add_child(new_node)
			$".".play("collect")
			necroplasm_collected = true
		else:
			pass


func _on_collection_timer_timeout() -> void:
	can_collect = true
