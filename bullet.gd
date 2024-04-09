extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 1000.0
	const RANGE = 1200.0
	
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
