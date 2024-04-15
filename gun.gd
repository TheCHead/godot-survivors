extends Area2D

var _damage = 1.0;
var _cooldown = 1.0;

var timer : Timer

func _ready():
	timer = Timer.new()
	
	timer.wait_time = _cooldown
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	
	add_child(timer)
	timer.start()
	

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front() as PhysicsBody2D
		look_at(target_enemy.global_position)
	
func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	new_bullet.init(_damage)


func _on_timer_timeout():
	shoot()
	
func damage_up():
	_damage += 0.5
	
func cool_down():
	_cooldown *= 0.9
	timer.wait_time = _cooldown
