extends Node

const boosted_speed := 1000													## speed after sudden death

var bullet_speed := 550

var sudden_death_timer: Timer												## timer for boosting bullet speed (to avoid draws)

func _ready():
	setup_sudden_death_timer()

func _on_sudden_death_timer_timeout():										## boost speed for both old and new bullets
	bullet_speed = boosted_speed

func setup_sudden_death_timer():											## sets up timer
	sudden_death_timer = Timer.new()
	sudden_death_timer.one_shot = true
	sudden_death_timer.wait_time = 60.0
	sudden_death_timer.timeout.connect(_on_sudden_death_timer_timeout)
	add_child(sudden_death_timer)
	sudden_death_timer.start()
