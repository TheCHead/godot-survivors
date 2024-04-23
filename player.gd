extends CharacterBody2D

signal health_depleted
signal lvl_up

var _health = 100.0
var _xp = 0
var _xp_to_lvl_up = 5
var _lvl = 1
var _speed = 600
@export var xp_bar : ProgressBar

func _ready():
	xp_bar.value = _xp
	xp_bar.max_value = _xp_to_lvl_up


func _physics_process(delta):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * _speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlaping_bodies = %HurtBox.get_overlapping_bodies()
	
	_health -= DAMAGE_RATE * overlaping_bodies.size() * delta
	
	%ProgressBar.value = _health
	
	if _health <= 0.0:
		health_depleted.emit()
		

func gain_xp():
	_xp += 1
	xp_bar.value = _xp
	if _xp >= _xp_to_lvl_up:
		_lvl += 1
		%ProgressBar/XPLabel.text = "lvl %s" % str(_lvl)
		_xp = 0
		_xp_to_lvl_up = snapped(_xp_to_lvl_up * 1.1, 1)
		xp_bar.value = _xp
		xp_bar.max_value = _xp_to_lvl_up
		lvl_up.emit()
	


func _on_collection_box_body_entered(body):
	if body.is_in_group("exp"):
		gain_xp()
		body.queue_free()
		
func apply_upgrade(upgrade:Upgrade):
	print("Applying upgrade %s" % upgrade.name)
	match upgrade.type:
		Upgrade.Type.hp_up:
			_health += 10
			pass
		Upgrade.Type.damage_up:
			%Gun.damage_up()
			pass
		Upgrade.Type.speed_up:
			_speed += 60
			pass
		Upgrade.Type.range_up:
			%GatherBox.scale *= 1.1
			pass
		Upgrade.Type.cooldown_down:
			%Gun.cool_down()
			pass
	pass
