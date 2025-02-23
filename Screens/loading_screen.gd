extends Control

@export var loading_bar : ProgressBar


var Scene_path : String
var progress : Array

var update : float = 0.0

func _ready():
	Scene_path = "res://Screens/level_1.tscn"
	ResourceLoader.load_threaded_request(Scene_path)
	

func _process(delta):
	ResourceLoader.load_threaded_get_status(Scene_path, progress)
	
	if progress[0] > update:
		update = progress[0]
	
	if loading_bar.value >= 1.0:
		if update >= 1.0:
			get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(Scene_path)
			)

	if loading_bar.value < update:
		loading_bar.value = lerp(loading_bar.value, update, delta)
	loading_bar.value += delta * 0.2 * \
	 	(0.5 if update >= 1.0 else clamp(0.9 - loading_bar.value, 0.0, 1.0))
	
	
