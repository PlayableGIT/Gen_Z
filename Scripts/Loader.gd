extends Node

var loading_screen = load("res://Screens/Loading_screen.tscn")
var scene_path : String
var scene_rel: String

func change_level(path):
	scene_path = path
	get_tree().change_scene_to_packed(loading_screen)
	
func reload_level(path):
	scene_rel = path
	get_tree().change_scene_to_packed(loading_screen)
