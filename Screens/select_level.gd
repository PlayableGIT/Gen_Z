extends Control
var last_tut_screen 
var tut_array
@export var text_1: CompressedTexture2D
@export var text_2: CompressedTexture2D
@export var text_3: CompressedTexture2D
@export var text_4: CompressedTexture2D
@export var text_5: CompressedTexture2D
@export var text_55: CompressedTexture2D
@export var text_6: CompressedTexture2D
@export var text_7: CompressedTexture2D
@export var text_8: CompressedTexture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_viewport().size = DisplayServer.screen_get_size()
	tut_array = [text_1, text_2, text_3, text_4, text_5, text_55, text_6, text_7, text_8]

func _on_level_1_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	Loader.change_level("res://Screens/level_1.tscn")
	
func _on_level_2_pressed() -> void:
	$Button_Sound.play()
	if StatsAutoload.level_2 == true:
		await get_tree().create_timer(0.229).timeout
		Loader.change_level("res://Screens/level_2.tscn")
	else:
		pass

func _on_back_pressed() -> void:
	$Button_Sound.play()
	await get_tree().create_timer(0.229).timeout
	#get_tree().change_scene_to_file("res://Screens/Main_menu.tscn")
	$".".visible = false
	$"../VBoxContainer".visible = true


func _on_tutorial_pressed() -> void:
	$VBoxContainer2.visible = true
	$VBoxContainer3.visible = true
	$VBoxContainer4.visible = true


func _on_button_pressed() -> void:
	$VBoxContainer2.visible = false
	$VBoxContainer3.visible = false
	$VBoxContainer4.visible = false

var x = 0
func _on_next_pressed() -> void:
	if x < 8:
		$VBoxContainer2/Tutorial.texture = tut_array[x+1]
		print(tut_array[x+1])
		print(x)
		x += 1
	else:
		pass



func _on_prev_pressed() -> void:
	if x > 0:
		$VBoxContainer2/Tutorial.texture = tut_array[x-1]
		print(tut_array[x-1])
		print(x)
		x -= 1
	else:
		pass
