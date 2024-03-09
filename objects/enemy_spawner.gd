class_name EnemySpawner
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_new(player: Player, enemy_scene: PackedScene):
	var instance := enemy_scene.instantiate() as EnemyFlying
	
	add_child(instance)
	
	instance.position = position
	instance.player = player
	
	Audio.play_at("sounds/enemy_spawned1.wav,sounds/enemy_spawned2.wav,sounds/enemy_spawned3.wav,sounds/enemy_spawned4.wav,sounds/enemy_spawned5.wav", position)
