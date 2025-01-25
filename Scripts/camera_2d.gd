extends Camera2D

@export var MOVE_SPEED = 300
var left_limit = Vector2(915.0, 0)
var right_limit = Vector2(4738.0, 0)
var up_limit = Vector2(0, -800.0)
var down_limit = Vector2(0, -270.0)

func _process(delta):
	#print($".".position)
	if Input.is_action_pressed("ui_left") and $".".position >= left_limit:
		global_position += Vector2.LEFT * delta * MOVE_SPEED
	else:
		pass
	
	if Input.is_action_pressed("ui_right") and $".".position <= right_limit:
		global_position += Vector2.RIGHT * delta * MOVE_SPEED
	else:
		pass
	
	if Input.is_action_pressed("ui_up"):
		global_position += Vector2.UP * delta * MOVE_SPEED
	else:
		pass
	
	if Input.is_action_pressed("ui_down"):
		global_position += Vector2.DOWN * delta * MOVE_SPEED
	else:
		pass
	#print($".".position)
