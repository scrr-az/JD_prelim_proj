extends CharacterBody2D

@export var max_speed = 300												## maximum speed
@export var accel = 200000												## acceleration
@export var friction = 700000											## friction
@export var bullet_scene : PackedScene									## bullet scene, gets instantiated
@export var bullet_color : Color										## bullet color, depends on player

var input = Vector2.ZERO												## determines player movement direction

var deadzone : float = 0.2												## joystick deadzone
var target_angle : float												## angle to move controller players hand

var bullet_counter = 5													## number of bullets per player
var round_over : bool = false

@export var is_p1 = true												## boolean for player specific stuff
@onready var walk_animation = $SpriteWalk

func _ready() -> void:
	if not is_p1:
		$SpriteWalk.flip_h = 1

func _physics_process(delta):
	if not round_over:
		if is_p1:
			$Hand.look_at(get_global_mouse_position())						# moves hand to mouse
		else:
			var input_vec : Vector2 = Vector2(								# gets joystick input
				Input.get_axis("p2_lookleft", "p2_lookright"),
				Input.get_axis("p2_lookup", "p2_lookdown")
			)
			
			if input_vec.length() >= deadzone:								# gets hand angle
				target_angle = input_vec.angle() 
				
			if rotation != target_angle:									# points hand to angle
				$Hand.rotation = target_angle
				
		if Input.is_action_just_pressed("p1_shoot") and is_p1:				# p1 shoots
			change_bullet_color()
		if Input.is_action_just_pressed("p2_shoot") and not is_p1:			# p2 shoots
			change_bullet_color()
			
		player_movement(delta)

func get_input():
	if not round_over:
		if is_p1:
			input.x = int(Input.is_action_pressed("p1_right")) - int(Input.is_action_pressed("p1_left"))
			input.y = int(Input.is_action_pressed("p1_down")) - int(Input.is_action_pressed("p1_up"))
		else:
			input.x = int(Input.is_action_pressed("p2_right")) - int(Input.is_action_pressed("p2_left"))
			input.y = int(Input.is_action_pressed("p2_down")) - int(Input.is_action_pressed("p2_up"))
		
		return input.normalized()
	
func player_movement(delta):
	if not round_over:
		input = get_input()
		
		if input == Vector2.ZERO:
			walk_animation.stop()
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (4*friction * delta)
			else:
				velocity = Vector2.ZERO
		else:
			velocity += (input * accel * delta)
			velocity = velocity.limit_length(max_speed)
			walk_animation.play("default")
			walk_animation.flip_h = input.x < 0
		
		#if is_p1:
			#if velocity.x >= 0:											# flips player sprite depending on direction
				#$Sprite2D.flip_h = 0
			#else:
				#$Sprite2D.flip_h = 1
		#else:
			#if velocity.x >= 0:											# flips player sprite depending on direction
				#$Sprite2D.flip_h = 1
			#else:
				#$Sprite2D.flip_h = 0
		
		move_and_slide()
	
func change_bullet_color():
	if is_p1:
		Global.player_1_shot()
		bullet_color = Color(0.1, 0.745, 1)
	else:
		Global.player_2_shot()
		bullet_color = Color(1, 0.2, 0)
	fire()
	
func fire():											## creates bullet, plays sound
	if bullet_counter > 0:
		var bullet = bullet_scene.instantiate()
		
		bullet.get_node("BulletSprite").modulate = bullet_color	
		bullet.rot=$Hand.rotation
		bullet.pos=$Hand/HandSprite.global_position
		bullet.pos += Vector2(50, 0).rotated(bullet.rot)
		
		get_parent().add_child(bullet)
		
		Global.play_sound("res://audio/gunshot.wav")
		
		var current_scene = get_tree().current_scene.scene_file_path
		if current_scene != "res://scenes/main.tscn":
			bullet_counter = bullet_counter-1
		#print("R: " + str(bullet.rot) + " D: " + str(bullet.dir) + " S: " + str(bullet.speed))
		#print(str(bullet_counter))
	else:
		Global.play_sound("res://audio/empty.wav")
		
func death():
	# make all bullets stop moving and deactivate their collision so there are no more collisions
	get_tree().paused = true
		
	if is_p1:
		Global.play_sound("res://audio/p1_death.wav")
	else:
		Global.play_sound("res://audio/p2_death.wav")
	# play the death animation
	$SpriteWalk.visible = false
	$SpriteDead.visible = true
	$SpriteDead.play()
	await $SpriteDead.animation_finished
	
	get_tree().paused = false
	
	if is_p1:
		Global.player_2_won()
	else:
		Global.player_1_won()
	
	# get the number of the current scene from the file name and change scene to the next one
	var current_scene = get_tree().current_scene.scene_file_path
	var scene_number = int(current_scene.get_file().trim_prefix("level").trim_suffix(".tscn"))
	var next_scene = "res://scenes/level" + str(scene_number + 1) + ".tscn"

	if !ResourceLoader.exists(next_scene):
		next_scene = "res://scenes/main.tscn"
	
	get_tree().change_scene_to_file(next_scene)
		

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("bullet") && !area.get_parent().justShot:
		death()
