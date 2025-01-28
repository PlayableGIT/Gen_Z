extends Camera2D

@export var MOVE_SPEED = 300

@export var left_limit = 915.0
@export var right_limit = 4738.0
@export var up_limit = -900.0
@export var down_limit = 270.0

func _process(delta):
	# Wydrukuj bieżącą pozycję
	#print(global_position)

	# Ruch w lewo
	if Input.is_action_pressed("ui_left") and global_position.x > left_limit:
		global_position.x -= MOVE_SPEED * delta

	# Ruch w prawo
	if Input.is_action_pressed("ui_right") and global_position.x < right_limit:
		global_position.x += MOVE_SPEED * delta

	# Ruch w górę
	if Input.is_action_pressed("ui_up") and global_position.y > up_limit:
		global_position.y -= MOVE_SPEED * delta

	# Ruch w dół
	if Input.is_action_pressed("ui_down") and global_position.y < down_limit:
		global_position.y += MOVE_SPEED * delta
    
    	if Input.is_action_just_released("scroll_up") and $".".zoom.x < 1.5:
		$".".zoom.x += delta*SCROLL_SPEED
		$".".zoom.y += delta*SCROLL_SPEED
	else:
		pass
		
	if Input.is_action_just_released("scroll_down") and $".".zoom.x > 0.7:
		$".".zoom.x -= delta*SCROLL_SPEED
		$".".zoom.y -= delta*SCROLL_SPEED
	else:
		pass
