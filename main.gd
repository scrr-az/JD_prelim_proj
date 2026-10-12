extends Node2D

@export var timer_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("boasboas")
	var new_timer = timer_scene.instantiate()
	add_child(new_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
