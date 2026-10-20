extends Node

const boosted_speed := 1000													## speed after sudden death

var bullet_speed := 550

var end_of_times_timer: Timer												## timer for boosting bullet speed (to avoid draws)

var points1 : int = 0
var points2 : int = 0

var bullets1 : int = 5
var bullets2 : int = 5

func _ready():
	setup_end_of_times_timer()
	
func _process(_delta: float) -> void:
	var currentScene = get_tree().current_scene
	if currentScene && currentScene.scene_file_path == "res://scenes/level1.tscn" && (end_of_times_timer == null || end_of_times_timer.is_stopped()):
		end_of_times_timer.start()

func _on_end_of_times_timer_timeout():										## boost speed for both old and new bullets
	points1 = 0
	points2 = 0
	get_tree().change_scene_to_file("res://scenes/main.tscn")
#
#
func setup_end_of_times_timer():											## sets up timer
	end_of_times_timer = Timer.new()
	end_of_times_timer.one_shot = true
	end_of_times_timer.wait_time = 90.0
	end_of_times_timer.timeout.connect(_on_end_of_times_timer_timeout)
	add_child(end_of_times_timer)

func play_sound(sound_path : String):
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = load(sound_path)
	audio_player.volume_db = -15.0
	add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)
	
func player_1_won():
	points1 += 1
	
func player_2_won():
	points2 += 1
	
func player_1_shot():
	bullets1 -= 1

func player_2_shot():
	bullets2 -= 1
