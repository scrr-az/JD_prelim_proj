extends CharacterBody2D

var pos : Vector2													## bullet position
var rot : float														## bullet rotation (in radians)
var justShot : bool

func _ready():
	global_position = pos
	global_rotation = rot

func _physics_process(delta):
	velocity = Vector2(Global.bullet_speed, 0).rotated(rot)			# checks bullet speed via global script
	move_and_slide()												# bullet movement

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
		else:
			print("hit")
