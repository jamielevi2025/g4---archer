extends Area2D

class_name XPOrb

signal collected(amount: int)

var xp_value: int = 5
var vacuum_radius: float = 80.0
var collect_radius: float = 20.0
var vacuum_speed: float = 150.0
var is_being_vacuumed: bool = false
var xp_auto_collect_radius: float = 0.0

@onready var collect_sound: AudioStreamPlayer = $CollectSound


func _ready() -> void:
	add_to_group("orbs")


func _collect() -> void:
	collected.emit(xp_value)
	var sound = collect_sound
	remove_child(sound)
	get_tree().root.add_child(sound)
	sound.play()
	sound.finished.connect(sound.queue_free)
	queue_free()


func _process(delta: float) -> void:
	if Engine.time_scale == 0.0:
		return
	# Auto-collect toward archer if xp_shot upgrade is active
	if xp_auto_collect_radius > 0.0:
		var players: Array = get_tree().get_nodes_in_group("player")
		if not players.is_empty():
			var archer: Node2D = players[0]
			var archer_dist: float = global_position.distance_to(archer.global_position)
			if archer_dist <= collect_radius:
				_collect()
				return
			elif archer_dist <= vacuum_radius + xp_auto_collect_radius:
				var dir: Vector2 = (archer.global_position - global_position).normalized()
				var speed: float = vacuum_speed * lerp(1.0, 3.0, 1.0 - (archer_dist / (vacuum_radius + xp_auto_collect_radius)))
				global_position += dir * speed * delta
				is_being_vacuumed = true
				return

	# Mouse vacuum
	var mouse_pos: Vector2 = get_global_mouse_position()
	var dist: float = global_position.distance_to(mouse_pos)
	if dist <= collect_radius:
		_collect()
	elif dist <= vacuum_radius:
		is_being_vacuumed = true
		var dir: Vector2 = (mouse_pos - global_position).normalized()
		var speed: float = vacuum_speed * lerp(1.0, 3.0, 1.0 - (dist / vacuum_radius))
		global_position += dir * speed * delta
	else:
		is_being_vacuumed = false


func setup(value: int, auto_radius: float = 0.0) -> void:
	xp_value = value
	xp_auto_collect_radius = auto_radius
