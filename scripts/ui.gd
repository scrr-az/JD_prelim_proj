extends Control
# Called when the node enters the scene tree for the first time.

var countdownValue : int = 3

func _ready() -> void:
	get_tree().paused = true
	
	$Countdown/CountdownLabel.text = "%s" % countdownValue
	$Countdown/Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PointsPlayer1.text = "%s" % Global.points1
	$PointsPlayer2.text = "%s" % Global.points2

func _on_timer_timeout() -> void:
	countdownValue -= 1
	
	if countdownValue > 0:
		$Countdown/CountdownLabel.text = "%s" % countdownValue
		$Countdown/Timer.start()
	elif countdownValue == 0:
		$Countdown/CountdownLabel.text = "GO!"
		$Countdown/Timer.start()
	else:
		$Countdown/CountdownLabel.hide()
		get_tree().paused = false
