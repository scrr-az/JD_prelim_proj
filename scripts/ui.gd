extends Control
# Called when the node enters the scene tree for the first time.

var countdownValue : int = 3

func _ready() -> void:
	# it is only called when a new scene starts, so reset the bullets
	Global.bullets1 = 5
	Global.bullets2 = 5
	
	# stop everything while countdown
	get_tree().paused = true
	
	$Countdown/CountdownLabel.text = "%s" % countdownValue
	$Countdown/Timer.start()
	Global.play_sound("res://audio/countdown.wav")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$PointsPlayer1.text = "%s" % Global.points1
	$PointsPlayer2.text = "%s" % Global.points2
	
	# Turn the bullets that were used invisible in the ui
	var lastBullet = $ContainerBullets1.get_node_or_null("Bullet" + str(Global.bullets1 + 1))
	if(lastBullet):
		lastBullet.visible = false
		
	lastBullet = $ContainerBullets2.get_node_or_null("Bullet" + str(Global.bullets2 + 1))
	if(lastBullet):
		lastBullet.visible = false

func _on_timer_timeout() -> void:
	countdownValue -= 1
	
	if countdownValue > 0:
		$Countdown/CountdownLabel.text = "%s" % countdownValue
		$Countdown/Timer.start()
		Global.play_sound("res://audio/countdown.wav")
	elif countdownValue == 0:
		$Countdown/CountdownLabel.text = "GO!"
		Global.play_sound("res://audio/countdown_final.wav")
		$Countdown/Timer.start()
	else:
		$Countdown/CountdownLabel.hide()
		get_tree().paused = false
