
extends CharacterBody2D

@export var asset_holder: Resource

@onready var life_bar: ColorRect = $life/life_bar
@onready var cooldown: Timer = $cooldown
@onready var character: Polygon2D = $character

const SPEED = 50
const ACCELERATION_SPEED = 60


var life_left = 3
var target = null

var start_point_x = 0
var start_point_y = 0

var can_attack = true

func _ready() -> void:
	life_bar.scale.x = life_left / 3.0
	
	start_point_x = position.x
	start_point_y = position.y
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var to_x = start_point_x
	var to_y = start_point_y
	
	if target != null && can_attack:
		to_x = target.position.x
		to_y = target.position.y

	if abs(to_x - position.x) + abs(to_y - position.y) > 10 :
		
		var angle = -atan2(to_y-position.y, to_x - position.x)
		angle += deg_to_rad(+90)
		var x_incr = SPEED * delta * sin(angle)
		var y_incr = SPEED * delta * cos(angle)
		
		if x_incr < 0:
			$character.scale.x = 1
		else:
			$character.scale.x = -1

		var d_x = x_incr * SPEED
		var d_y = y_incr * SPEED

		velocity.x = move_toward(velocity.x, d_x, ACCELERATION_SPEED * delta)
		velocity.y = move_toward(velocity.y, d_y, ACCELERATION_SPEED * delta)
		
		move_and_slide()

func hit():
	life_left -= 1
	life_bar.scale.x = life_left / 3.0
	start_cooldown()
	if life_left <= 0:
		queue_free()
		
func start_cooldown():
	cooldown.start(3)
	can_attack = false
	

func attack(body: Node2D):
	start_cooldown()
	print("init")
	body.hit()

func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("detected - h");
		target = body


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("out - h")
		target = null


func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		attack(body)

func _on_cooldown_timeout() -> void:
	can_attack = true


func update_assets():
	print("updating")
	character.texture = asset_holder.henchmen_asset
	pass;
