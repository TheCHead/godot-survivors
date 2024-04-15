extends Node2D

@onready var lvl_up_canvas = %LvlUpCanvas
@onready var player = %Player

var _mob_spawn_cooldown = 2.0
var mob_timer : Timer
var mob_counter = 0

func _ready():
	mob_timer = Timer.new()
	
	mob_timer.wait_time = _mob_spawn_cooldown
	mob_timer.one_shot = false
	mob_timer.timeout.connect(spawn_mob)
	
	add_child(mob_timer)
	mob_timer.start()
	
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func spawn_mob():
	if mob_counter > 100:
		return
	var new_mob = preload("res://mob_slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	mob_counter += 1
	new_mob.on_death.connect(on_mob_dead)
	
func on_mob_dead():
	mob_counter -= 1


func _on_player_health_depleted():
	%GameOverCanvas.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_player_lvl_up():
	get_tree().paused = true
	lvl_up_canvas.display()
	_mob_spawn_cooldown *= 0.8
	mob_timer.wait_time = _mob_spawn_cooldown
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_lvl_up_canvas_upgrade_selected(upgrade):
	lvl_up_canvas.visible = false
	get_tree().paused = false
	player.apply_upgrade(upgrade)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
