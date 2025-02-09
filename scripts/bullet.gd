extends Area2D

@export var asset_holder: Resource

var speed = 1200

var direction = 0;
var life_time = 200;
func _physics_process(delta):
	life_time -=1
	
	var dir = -deg_to_rad(direction - 90)
	position.x +=  speed * delta * sin(dir)
	position.y +=  speed * delta * cos(dir)
	rotation = deg_to_rad(direction)
	if life_time < 0:
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	print("hit", body)
	if body.is_in_group("enemies"):
		body.hit()
	queue_free()
	pass # Replace with function body.
