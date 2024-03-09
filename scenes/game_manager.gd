class_name GameManager
extends Node3D

# TODO: add subgroups
@export var spawn_curve: Curve
@export var spawn_curve_start_time: float
@export var spawn_curve_end_time: float
@export var spawn_per_minute_start: float
@export var spawn_per_minute_end: float

# TODO: get by group
@export var spawn_points: Array[EnemySpawner]
@export_file var enemy_scene_path: String

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var enemy_scene: PackedScene = load(enemy_scene_path)

var total_time: float = 0
var next_spawn: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawn_points.is_empty():
		print_debug("ERROR: spawn_points in GameManager is empty!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	increment_time(delta)
	
	var t: float = total_time - spawn_curve_start_time
	t = clamp(t, 0.0, 1.0)
	
	var current_spawns_per_minute := spawn_per_minute_start + (spawn_curve.sample(t) * spawn_per_minute_end)
	
	if next_spawn > (1.0 / (current_spawns_per_minute)) * 60.0:
		trigger_spawns()
		next_spawn = 0

func increment_time(delta):
	total_time += delta
	next_spawn += delta
	
func trigger_spawns():
	for spawn in spawn_points:
		spawn.spawn_new(player, enemy_scene)
