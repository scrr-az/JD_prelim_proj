extends CharacterBody2D

var pos : Vector2													## bullet position
var rot : float														## bullet rotation (in radians)
var justShot : bool = true
var stopped: bool = false

func _ready():
	global_position = pos
	global_rotation = rot

func _physics_process(delta):
	if stopped:
		return
	
	velocity = Vector2(Global.bullet_speed, 0).rotated(rot)
	#move_and_slide()
	# bullet movement (returns a KinematicCollision2D body if it collides with something)
	var collisionInfo = move_and_collide(delta * velocity)
	
	if collisionInfo:
		#print(collisionInfo.get_collider().is_in_group("obstacle"))
		var newVel = velocity.bounce(collisionInfo.get_normal())
		global_rotation = atan2(newVel.y, newVel.x)
		rot = atan2(newVel.y, newVel.x)
	
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
			
	if area.is_in_group("player"):
		if justShot:
			justShot = false
