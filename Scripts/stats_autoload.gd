extends Node

var zombie_damage: int = 5
var survivor_damage: int = 10
var survivor_gun_damage: int = 2
var nekroplazma: int = 20
var level_2 = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_tutorial_button_down() -> void:
	nekroplazma = 70
