extends CanvasLayer
signal ui_mouse_lock(a: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer.visible = false
	ui_mouse_lock.connect(mouse_lock)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Input.is_action_just_released("right_mouse"):
		$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon.png")

func _on_texture_button_pressed() -> void:
	if $PanelContainer.visible == false:
		$PanelContainer.visible = true
	else:
		$PanelContainer.visible = false
	$button_sound.play()
	ui_mouse_lock.emit(true)

func mouse_lock(_a):
	pass


func _on_button_pressed() -> void:
	$button_sound.play()
	$"..".add_to_group("casual_zombie")
	$AspectRatioContainer/TextureRect.texture = load("res://textures/casual_zombie_icon.png")
	if $"..".is_in_group("cheerleader_zombie"):
		$"..".remove_from_group("cheerleader_zombie")
	ui_mouse_lock.emit(true)


func _on_button_2_pressed() -> void:
	$button_sound.play()
	$"..".add_to_group("cheerleader_zombie")
	$AspectRatioContainer/TextureRect.texture = load("res://textures/cheerleader_zombie_icon.png")
	if $"..".is_in_group("casual_zombie"):
		$"..".remove_from_group("casual_zombie")
	ui_mouse_lock.emit(true)
