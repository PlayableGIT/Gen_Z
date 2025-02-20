extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	pass


func _on_level_1_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	get_tree().change_scene_to_file("res://Screens/level_1.tscn")

func _on_level_2_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	get_tree().change_scene_to_file("res://Screens/level_2.tscn")

func _on_back_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	#get_tree().change_scene_to_file("res://Screens/Main_menu.tscn")
	$".".visible = false
	$"../VBoxContainer".visible = true
