extends StaticBody2D

@onready var parent = get_parent() as PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent is PathFollow2D:
		parent.set_progress(parent.get_progress() + 200 * delta)
