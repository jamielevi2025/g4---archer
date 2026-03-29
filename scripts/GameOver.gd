extends CanvasLayer

class_name GameOver

signal restart_pressed
signal quit_pressed
signal menu_pressed

var current_score: int = 0
var _current_level: int = 0


func _ready() -> void:
	$VBoxContainer/RestartButton.pressed.connect(func(): restart_pressed.emit())
	$VBoxContainer/MenuButton.pressed.connect(func(): menu_pressed.emit())
	$VBoxContainer/QuitButton.pressed.connect(func(): quit_pressed.emit())
	$VBoxContainer/SubmitButton.pressed.connect(on_submit_pressed)
	$VBoxContainer/LeaderboardButton.pressed.connect(on_leaderboard_pressed)


func show_screen(level: int, wave: int, score: int) -> void:
	_current_level = level
	current_score = score
	visible = true
	$VBoxContainer/StatsLabel.text = "Level " + str(level) + " - Wave " + str(wave) + "\nScore: " + str(score)
	$VBoxContainer/SubmitStatus.text = ""
	$VBoxContainer/NameInput.text = ""
	$VBoxContainer/SubmitButton.disabled = false


func on_submit_pressed() -> void:
	if $VBoxContainer/NameInput.text.strip_edges() == "":
		$VBoxContainer/SubmitStatus.text = "Please enter your name"
		return
	$VBoxContainer/SubmitButton.disabled = true
	$VBoxContainer/SubmitStatus.text = "Submitting..."
	Supabase.submit_score($VBoxContainer/NameInput.text.strip_edges(), current_score, _current_level)
	Supabase.score_submitted.connect(func():
		$VBoxContainer/SubmitStatus.text = "Score submitted!"
	, CONNECT_ONE_SHOT)


func on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Leaderboard.tscn")
