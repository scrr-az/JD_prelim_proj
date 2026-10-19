extends CharacterBody2D

var pos : Vector2													## bullet position
var rot : float														## bullet rotation (in radians)
var justShot : bool = false
var stopped: bool = false

#var collision_buffer_timer: Timer
#var afterimage_timer : Timer

func _ready():
	global_position = pos
	global_rotation = rot
	#setup_afterimage_timer()

func _physics_process(delta):
	if stopped:
		return
	
	velocity = Vector2(Global.bullet_speed, 0).rotated(rot)
	#move_and_slide()
	# bullet movement (returns a KinematicCollision2D body if it collides with something)
	var collisionInfo = move_and_collide(delta * velocity)
	
	if collisionInfo:
		#collision_buffer()
		#print(collisionInfo.get_collider().is_in_group("obstacle"))
		var newVel = velocity.bounce(collisionInfo.get_normal())
		global_rotation = atan2(newVel.y, newVel.x)
		rot = atan2(newVel.y, newVel.x)
		
		Global.play_sound("res://audio/ricochet.wav")
	
func stop_bullet():
	stopped = true
	$BulletArea2D.set_deferred("disabled", true)

func _on_area_2d_area_entered(area: Area2D):						## checks collisions
	if area.is_in_group("portal"):									# detects portal
		#print("boas")
		if area.position.x == 0:									# only top or bottom portals
			position.y *= -1
		else:														# side portals
			position.x *= -1
	#if area.is_in_group("player"):
		#if justShot:
			#justShot = false
			
#func collision_buffer():											## avoid caravan bug
	#$BulletArea2D.set_deferred("monitoring", false) 
	#$BulletArea2D.set_deferred("monitorable", false)
	#timer = Timer.new()
	#timer.one_shot = true
	#timer.wait_time = 0.05
	#timer.timeout.connect(_on_collision_buffer_timer_timeout)
	#add_child(timer)
	#timer.start()

#func _on_collision_buffer_timer_timeout():
	#$BulletArea2D.set_deferred("monitoring", true)
	#$BulletArea2D.set_deferred("monitorable", true)

#func setup_afterimage_timer():										## cool afterimage effect (look up SotN back dash)
	#afterimage_timer = Timer.new()
	#afterimage_timer.wait_time = 0.3
	#afterimage_timer.timeout.connect(_on_afterimage_timer_timeout)
	#add_child(afterimage_timer)
	#afterimage_timer.start()
	#
#func _on_afterimage_timer_timeout():
	#bullet_speed = boosted_speed
