extends Node

# Code adapted from KidsCanCode

var num_players = 12
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

var spatial_available: Array[AudioStreamPlayer3D] = []
var spatial_queue: Array[Array] = []

func _ready():
	for i in num_players:
		add_player()
		add_player_spatial()

func add_player():
	var p = AudioStreamPlayer.new()
	add_child(p)

	available.append(p)

	p.volume_db = -10
	p.finished.connect(_on_stream_finished.bind(p))
	p.bus = bus
	
func add_player_spatial():
	var p = AudioStreamPlayer3D.new()
	add_child(p)

	spatial_available.append(p)

	p.volume_db = -10
	p.finished.connect(_on_stream_finished_spatial.bind(p))
	p.bus = bus

func _on_stream_finished(stream):
	available.append(stream)

func _on_stream_finished_spatial(stream):
	spatial_available.append(stream)

func play(sound_path):  # Path (or multiple, separated by commas)
	var sounds = sound_path.split(",")
	queue.append("res://" + sounds[randi() % sounds.size()].strip_edges())

func play_at(sound_path, position: Vector3):  # Path (or multiple, separated by commas)
	var sounds = sound_path.split(",")
	spatial_queue.append(["res://" + sounds[randi() % sounds.size()].strip_edges(), position])

func _process(_delta):
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available[0].pitch_scale = randf_range(0.9, 1.1)

		available.pop_front()
		
	if not spatial_queue.is_empty() and not spatial_available.is_empty():
		var next = spatial_queue.pop_front()
		spatial_available[0].stream = load(next[0])
		spatial_available[0].position = next[1]
		spatial_available[0].play()
		spatial_available[0].pitch_scale = randf_range(0.9, 1.1)

		spatial_available.pop_front()
