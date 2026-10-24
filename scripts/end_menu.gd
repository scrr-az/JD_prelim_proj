extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.play_sound("res://audio/countdown.wav")
	
	$PointsPlayer1.text = "%s" % Global.points1
	$PointsPlayer2.text = "%s" % Global.points2
	
	# Change to the graveyard sprites and stop bullets from being detected
	if Global.points1 > Global.points2:
		$Player2/SpriteGrave.visible = true
		$Player2/SpriteWalk.visible = false
		$Player2/Hand/HandSprite.visible = false
		$Player2.round_over = true
	elif Global.points2 > Global.points1:
		$Player1/SpriteGrave.visible = true
		$Player1/SpriteWalk.visible = false
		$Player1/Hand/HandSprite.visible = false
		$Player1.round_over = true
	else:
		$Player1/SpriteGrave.visible = true
		$Player1/SpriteWalk.visible = false
		$Player1/Area2D/CollisionShape2D.disabled = true
		$Player2/SpriteGrave.visible = true
		$Player2/SpriteWalk.visible = false
		$Player2/Area2D/CollisionShape2D.disabled = true


func _on_back_area_area_entered(_area: Area2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")
	Global.points1 = 0
	Global.points2 = 0
