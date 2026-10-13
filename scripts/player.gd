extends CharacterBody2D

@export var max_speed = 400												## maximum speed
@export var accel = 200000												## acceleration
@export var friction = 700000											## friction
@export var bullet_scene : PackedScene									## bullet scene, gets instantiated
@export var bullet_color : Color										## bullet color, depends on player

var input = Vector2.ZERO												## determines player movement direction

var bullet_counter = 5													## number of bullets per player

@export var is_p1 = true												## boolean for player specific stuff

func _physics_process(delta):
	$Hand.look_at(get_global_mouse_position())
	#print(str(bullet_counter))
	if Input.is_action_just_pressed("shoot"):
		change_bullet_color()
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
		
	if velocity.x >= 0:											# flips player sprite depending on direction
		$Sprite2D.flip_h = 0
	else:
		$Sprite2D.flip_h = 1
	
	move_and_slide()
	
func change_bullet_color():
	if is_p1:
		bullet_color = Color(0.1, 0.745, 1)
	else:
		bullet_color = Color(1, 0.2, 0)
	fire()
	
func fire():											## creates bullet
	if bullet_counter > 0:
		var bullet = bullet_scene.instantiate()
		bullet.get_node("BulletSprite").modulate = bullet_color
		bullet.dir=$Hand.rotation
		bullet.pos=$Hand.global_position
		bullet.rot=$Hand.rotation
		get_parent().add_child(bullet)
		bullet_counter = bullet_counter-1
		#print("R: " + str(bullet.rot) + " D: " + str(bullet.dir) + " S: " + str(bullet.speed))
		#print(str(bullet_counter))
