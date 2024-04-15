extends CharacterBody2D

signal health_depleted
signal lvl_up

var health = 100.0
var xp = 0
var xp_to_lvl_up = 5
var lvl = 1
var speed = 600

func _physics_process(delta):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlaping_bodies = %HurtBox.get_overlapping_bodies()
	
	health -= DAMAGE_RATE * overlaping_bodies.size() * delta
	
	%ProgressBar.value = health
	
	if health <= 0.0:
		health_depleted.emit()
		

func gain_xp():
	xp += 1
	if xp >= xp_to_lvl_up:
		lvl += 1
		%ProgressBar/XPLabel.text = "lvl %s" % str(lvl)
		xp = 0
		xp_to_lvl_up = snapped(xp_to_lvl_up * 1.1, 1)
		lvl_up.emit()
	


func _on_collection_box_body_entered(body):
	if body.is_in_group("exp"):
		gain_xp()
		body.queue_free()
		
func apply_upgrade(upgrade:Upgrade):
	print("Applying upgrade %s" % upgrade.name)
	match upgrade.type:
		Upgrade.Type.hp_up:
			health += 10
			pass
		Upgrade.Type.damage_up:
			%Gun.damage_up()
			pass
		Upgrade.Type.speed_up:
			speed += 60
			pass
		Upgrade.Type.range_up:
			%GatherBox.scale *= 1.1
			pass
		Upgrade.Type.cooldown_down:
			%Gun.cool_down()
			pass
	pass
