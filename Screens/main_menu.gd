extends Control

func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	pass
func _on_play_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	#get_tree().change_scene_to_file("res://Screens/select_level.tscn")
	$Select_level.visible = true
	$VBoxContainer.visible = false

func _on_exit_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	get_tree().quit()


func _on_menu_ambient_finished() -> void:
	$Menu_Ambient.play()
