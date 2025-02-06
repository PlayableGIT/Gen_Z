extends Control

@onready var main = $"../../"

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	$Button_Sound.play()
	main.pauseMenu()


func _on_restart_pressed() -> void:
	$Button_Sound.play()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	$Button_Sound.play()
	get_tree().quit()
