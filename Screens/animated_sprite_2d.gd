extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$".".global_position = get_global_mouse_position()
	if $"../Camera2D".is_in_group("mouse_lock") and $"../Camera2D".is_in_group("casual_zombie") != true or $"../Camera2D".is_in_group("cheerleader_zombie") != true:
		$".".visible = false
	if $"../Camera2D".is_in_group("mouse_lock") != true and ($"../Camera2D".is_in_group("casual_zombie") or $"../Camera2D".is_in_group("cheerleader_zombie")):
		$".".visible = true
