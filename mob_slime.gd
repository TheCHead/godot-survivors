extends CharacterBody2D

var health = 3
@export var speed : float = 300.0
@export var acceleration : float = 5.0
@onready var player = get_node("/root/Game/Player")
@onready var navigation_agent_2d = $NavigationAgent2D
signal on_death

var nav_update_frame_counter : int = 0
var _nav_update_rate = 30

var _nav_update_delay = 0
static var mob_counter = 0

func _ready():
	%Slime.play_walk()
	mob_counter += 1

	
func set_frame_counter(frame):
	nav_update_frame_counter = roundi(fmod(frame, _nav_update_rate))
	_nav_update_delay = roundi(fmod(mob_counter, _nav_update_rate))
	nav_update_frame_counter -= _nav_update_delay
	
func _physics_process(delta):
	if nav_update_frame_counter == _nav_update_rate:
		_update_nav_target()
	
	nav_update_frame_counter += 1
	
	var player_dir = navigation_agent_2d.get_next_path_position() - global_position
	player_dir = player_dir.normalized()
	
	#var player_dir = global_position.direction_to(player.global_position)
	
	velocity = velocity.lerp(player_dir * speed, acceleration * delta)
	move_and_slide()

func take_damage(damage):
	%Slime.play_hurt()
	
	health -= damage
	
	if health <= 0:
		
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		get_parent().add_child(new_smoke)
		new_smoke.global_position = global_position
		
		const XP = preload("res://xp_drop.tscn")
		var new_xp = XP.instantiate()
		get_parent().call_deferred("add_child", new_xp)
		new_xp.global_position = global_position
		
		on_death.emit()
		queue_free()


func _update_nav_target():
	nav_update_frame_counter = 0
	navigation_agent_2d.target_position = player.global_position
