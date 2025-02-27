extends CanvasLayer

signal ui_mouse_lock(a: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer.visible = false

	ui_mouse_lock.connect(mouse_lock)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Input.is_action_just_released("right_mouse"):
		$buzz.play()
		$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon1_anim.png")
		await get_tree().create_timer(0.1).timeout
		$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon2_anim.png")
		await get_tree().create_timer(0.1).timeout
		$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon3_anim.png")
		await get_tree().create_timer(0.1).timeout
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
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon1_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon2_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon3_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/casual_zombie_icon.png")
	if $"..".is_in_group("cheerleader_zombie"):
		$"..".remove_from_group("cheerleader_zombie")
	ui_mouse_lock.emit(true)


func _on_button_2_pressed() -> void:
	$button_sound.play()
	$"..".add_to_group("cheerleader_zombie")
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon1_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon2_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/no_zombie_icon3_anim.png")
	await get_tree().create_timer(0.1).timeout
	$AspectRatioContainer/TextureRect.texture = load("res://textures/cheerleader_zombie_icon.png")
	if $"..".is_in_group("casual_zombie"):
		$"..".remove_from_group("casual_zombie")
	ui_mouse_lock.emit(true)




func _on_grid_container_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_grid_container_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_button_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_button_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_button_2_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_button_2_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_texture_button_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_texture_button_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_texture_rect_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_texture_rect_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_pause_button_pressed() -> void:
	Engine.time_scale = 0.00001

func _on_slow_button_pressed() -> void:
	if Engine.time_scale == 0.1:
		pass
	elif Engine.time_scale == 0.00001:
		Engine.time_scale = 0.1
	else:
		$slow.play()
		Engine.time_scale = 0.1

func _on_play_button_pressed() -> void:
	if Engine.time_scale == 0.1:
		$slow_to_play.play()
	if Engine.time_scale == 0.00001:
		$slow_to_play.play()
	Engine.time_scale = 1


func _on_pause_button_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_pause_button_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")


func _on_play_button_mouse_entered() -> void:
	$"..".add_to_group("mouse_lock")


func _on_play_button_mouse_exited() -> void:
	$"..".remove_from_group("mouse_lock")
