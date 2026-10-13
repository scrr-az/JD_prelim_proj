extends Node

const BOOSTED_SPEED := 750

var bullet_speed := 500

var speed_timer: Timer

func _ready():
	speed_timer = Timer.new()
	speed_timer.one_shot = true
	speed_timer.wait_time = 2.0
	speed_timer.timeout.connect(_on_speed_timer_timeout)
	add_child(speed_timer)
	speed_timer.start()

func _on_speed_timer_timeout():
	bullet_speed = BOOSTED_SPEED  # affects bullets created from now on
	get_tree().set_group("bullets", "speed", BOOSTED_SPEED)

#extends Node2D
#
#@export var bullet_timer_scene: PackedScene
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	##print("boasboas")
	#var bullet_timer = bullet_timer_scene.instantiate()
	#add_child(bullet_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
