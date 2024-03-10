class_name EnemyWalking
extends RigidBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D

@export var mesh: Node3D
@export var move_speed := 5.0
@export var attack_damage := 1.0
@export var ignore_timer: Timer

const KNOCK_BACK_HEIGHT = 1
const KNOCK_BACK_STRENGTH = 5.0

var player: Node3D
var health := 100
var time := 0.0
var destroyed := false
var printed := false
var ignore_collision := false

func _ready():
	pass
	
func _physics_process(delta):
	var direction := agent.get_next_path_position() - global_position
	var collision := move_and_collide(direction.normalized() * delta * move_speed)
	
	if ignore_collision:
		return
	
	if collision == null:
		return
	
	var collider = collision.get_collider()
	if collider.has_method("damage"):
		collider.damage(attack_damage)
		ignore_collision = true
		ignore_timer.start()
		knock_back()

func _process(_delta):
	var direction = (player.global_position - global_position).normalized()
	mesh.look_at(player.position + Vector3(0, 0.5, 0), Vector3.UP, true)  # Look at player
	mesh.rotate_y(-90)

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

func _on_i_frame_timer_timeout():
	ignore_collision = false
