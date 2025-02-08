extends Control

@onready var main = $"../../"

func _ready():
	$".".visible = false
	get_tree().paused = false  # Reset na starcie
	Engine.time_scale = 1.0


func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_released("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	$Button_Sound.play()
	main.pauseMenu()


func _on_restart_pressed() -> void:
	$Button_Sound.play()
	get_tree().paused = false
	Engine.time_scale = 1.0
	await get_tree().create_timer(0.1).timeout
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	$Button_Sound.play()
	get_tree().quit()
