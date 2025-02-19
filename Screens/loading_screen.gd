extends Control

@export var loading_bar : ProgressBar


var Scene_path : String
var progress : Array
func _ready():
	Scene_path = "res://Screens/level_1.tscn"
	ResourceLoader.load_threaded_request(Scene_path)
	

func _process(delta):
	ResourceLoader.load_threaded_get_status(Scene_path, progress)
	
	
	loading_bar.value = progress[0]
	
	
	if loading_bar.value >= 1.0:
		get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(Scene_path)
		)
		
