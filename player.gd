extends CharacterBody2D

@export var max_speed = 400
@export var accel = 1300
@export var friction = 600
var bullet_path = preload("res://bullet.tscn")

var input = Vector2.ZERO

@export var is_p1 = true

func _physics_process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		fire()
	player_movement(delta)

func get_input():
	if is_p1:
		input.x = int(Input.is_action_pressed("p1_right")) - int(Input.is_action_pressed("p1_left"))
		input.y = int(Input.is_action_pressed("p1_down")) - int(Input.is_action_pressed("p1_up"))
	else:
		input.x = int(Input.is_action_pressed("p2_right")) - int(Input.is_action_pressed("p2_left"))
		input.y = int(Input.is_action_pressed("p2_down")) - int(Input.is_action_pressed("p2_up"))
	
	return input.normalized()
	
func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (4*friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
		
	move_and_slide()
	
func fire():
	if is_p1:
		var bullet = bullet_path.instantiate()
		bullet.dir=rotation
		bullet.pos=$BulletSpawn.global_position
		bullet.rot=global_rotation
		get_parent().add_child(bullet)
		#print("R: " + str(bullet.rot) + " D: " + str(bullet.dir) + " S: " + str(bullet.speed))
