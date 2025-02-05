extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_texture_button_pressed() -> void:
	if $PanelContainer.visible == false:
		$PanelContainer.visible = true
	else:
		$PanelContainer.visible = false


func _on_button_pressed() -> void:
	$"..".add_to_group("casual_zombie")
	if $"..".is_in_group("cheerleader_zombie"):
		$"..".remove_from_group("cheerleader_zombie")


func _on_button_2_pressed() -> void:
	$"..".add_to_group("cheerleader_zombie")
	if $"..".is_in_group("casual_zombie"):
		$"..".remove_from_group("casual_zombie")
