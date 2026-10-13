extends CharacterBody2D

var speed = 500						# bullet speed
var pos:Vector2						# bullet position
var rot:float						# bullet rotation (radians)
var dir:float						# bullet direction (radians)

func _ready():
	global_position=pos
	global_rotation=rot

func _physics_process(delta):
	velocity = Vector2(Global.bullet_speed, 0).rotated(dir)
	move_and_slide()							# bullet movement

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("portal"):				# detects portal
		#print("boas")
		if area.position.x == 0:				# only top or bottom
			position.y *= -1
		else:									# side portals
			position.x *= -1
	
#func _on_collision(body):
	#if body.is_in_group("player"):
		#body.queue_free()
	#queue_free()
