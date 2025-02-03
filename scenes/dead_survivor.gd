extends AnimatedSprite2D
var can_collect = false
var necroplasm_collected = false
var button_fade = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Button.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print($Control/Button.modulate.a)
	if button_fade == true:
		$Control/Button.modulate.a += 1 * delta
	if $Control/Button.modulate.a >= 0.7:
		button_fade = false

func _on_collection_timer_timeout() -> void:
	can_collect = true
	button_fade = true

func _on_button_pressed() -> void:
	print("jajebe")
	if necroplasm_collected == false and can_collect == true:
		var new_node = preload("res://necroplasm.tscn").instantiate()
		get_tree().current_scene.add_child(new_node)
		$".".play("collect")
		$AudioStreamPlayer.play()
		necroplasm_collected = true
		$Control/Button.visible = false
		$Control/Button.disabled = true
