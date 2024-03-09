extends Node3D

@export_file var enemy_scene: String
@export var spawns_per_minute: float
@export var immediate_spawn: bool

@onready var player: Node3D = get_tree().get_first_node_in_group("Player")

var spawn_timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if immediate_spawn:
		spawn_new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spawn_timer += delta
	
	if spawn_timer > (1.0 / spawns_per_minute) * 60:
		spawn_new()
		spawn_timer = 0

func spawn_new():
	var tscn: PackedScene = load(enemy_scene)
	var instance := tscn.instantiate() as Enemy
	
	add_child(instance)
	
	instance.position = position
	instance.player = player
