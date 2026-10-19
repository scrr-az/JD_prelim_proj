extends Node2D

func _on_start_area_area_entered(_area: Area2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level1.tscn")
