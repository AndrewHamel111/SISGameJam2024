class_name EnemyWalking
extends RigidBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var mesh: Node3D
@export var move_speed := 3.0
@export var attack_damage := 1.0

const KNOCK_BACK_HEIGHT = 1
const KNOCK_BACK_STRENGTH = 3.0

var player: Node3D
var health := 100
var time := 0.0
var destroyed := false
var printed := false
var ignore_timer := 0.0

func _ready():
	pass
	
func _physics_process(delta):
	
	if ignore_timer > 0:
		ignore_timer -= delta
		return
	
	var direction := agent.get_next_path_position() - global_position
	direction.y = 0
	var collision := move_and_collide(direction.normalized() * delta * move_speed)
	
	if collision == null:
		return
	
	var collider = collision.get_collider()
	if collider.has_method("damage"):
		collider.damage(attack_damage)
		ignore_timer = 0.8
		knock_back()

func _process(_delta):
	if ignore_timer > 0:
		return
		
	var direction = (player.global_position - global_position).normalized()
	mesh.look_at(player.position, Vector3.UP, true)  # Look at player

func damage(amount):
	Audio.play("sounds/enemy_hurt.ogg")

	health -= amount

	if health <= 0 and !destroyed:
		destroy()

func destroy():
	Audio.play("sounds/enemy_destroy.ogg")

	destroyed = true
	queue_free()

func knock_back():
	var knock_dir := global_position - player.global_position
	knock_dir.y = KNOCK_BACK_HEIGHT
	apply_impulse(knock_dir * KNOCK_BACK_STRENGTH)

func _update_target():
	agent.target_position = player.position
