extends Camera2D

@export var MOVE_SPEED = 1500
@export var SCROLL_SPEED = 3
@export var left_limit = -2500.0
@export var right_limit = 13000.0
@export var up_limit = -900.0
@export var down_limit = 800.0
@export var level_done = false

var otoczenie = AudioServer.get_bus_index("Environment")

func _ready() -> void:
	pass
func _process(delta):
	# Wydrukuj bieżącą pozycję
	#print(global_position)
	if Engine.time_scale == 1:
		MOVE_SPEED = 1500
		SCROLL_SPEED = 3
	if Engine.time_scale == 0.1:
		MOVE_SPEED = 15000
		SCROLL_SPEED = 30
	if Engine.time_scale == 0.00001:
		MOVE_SPEED = 150000000
		SCROLL_SPEED = 300000

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
		
	if Input.is_action_just_released("scroll_down") and $".".zoom.x > 0.5:
		$".".zoom.x -= delta*SCROLL_SPEED
		$".".zoom.y -= delta*SCROLL_SPEED
	else:
		pass
