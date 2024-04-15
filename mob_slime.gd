extends CharacterBody2D

var health = 3
@onready var player = get_node("/root/Game/Player")
signal on_death

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var playerDir = global_position.direction_to(player.global_position)
	
	velocity = playerDir * 300.0
	move_and_slide()

func take_damage(damage):
	%Slime.play_hurt()
	
	health -= damage
	
	if health <= 0:
		on_death.emit()
		queue_free()
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var new_smoke = SMOKE.instantiate()
		get_parent().add_child(new_smoke)
		new_smoke.global_position = global_position
		
		const XP = preload("res://xp_drop.tscn")
		var new_xp = XP.instantiate()
		get_parent().add_child(new_xp)
		new_xp.global_position = global_position
