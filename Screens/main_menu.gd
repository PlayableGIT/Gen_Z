extends Control

func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	pass
func _on_play_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	get_tree().change_scene_to_file("res://Screens/select_level.tscn")

func _on_exit_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	get_tree().quit()
