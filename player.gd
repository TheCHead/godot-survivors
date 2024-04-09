extends CharacterBody2D

signal health_depleted
var health = 100.0
var xp = 0
var xp_to_lvl_up = 5
var lvl = 1

func _physics_process(delta):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * 600
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
	


func _on_collection_box_body_entered(body):
	if body.is_in_group("exp"):
		gain_xp()
		body.queue_free()
