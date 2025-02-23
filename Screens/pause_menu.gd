extends Control

@onready var main = $"../../"
var akt_scena
func _ready():
	$".".visible = false
	get_tree().paused = false  # Reset na starcie
	Engine.time_scale = 1.0


func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true



func _on_resume_pressed() -> void:
	$Button_Sound.play()
	main.pauseMenu()


func _on_restart_pressed() -> void:
	$Button_Sound.play()
	get_tree().paused = false
	Engine.time_scale = 1.0
	await get_tree().create_timer(0.1).timeout
	#get_tree().reload_current_scene()
	akt_scena = get_tree().current_scene.scene_file_path
	Loader.change_level(akt_scena)

func _on_quit_pressed() -> void:
	$Button_Sound.play()
	get_tree().quit()
