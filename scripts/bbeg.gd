
extends CharacterBody2D

@export var asset_holder: Resource

@onready var life_bar: ColorRect = $life/life_bar
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var cooldown: Timer = $cooldown

const SPEED = 80
const ACCELERATION_SPEED = 120

var life_left = 6
var total_life = 6.0

var target = null

var start_point_x = 0
var start_point_y = 0

var can_attack = true


func _ready() -> void:
	life_bar.scale.x = life_left / total_life
	start_point_x = position.x
	start_point_y = position.y



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
			$sprite2D.scale.x = -1
		else:
			$sprite2D.scale.x = 1


		var d_x = x_incr * SPEED
		var d_y = y_incr * SPEED

		velocity.x = move_toward(velocity.x, d_x, ACCELERATION_SPEED * delta)
		velocity.y = move_toward(velocity.y, d_y, ACCELERATION_SPEED * delta)
		
		
	if velocity.x != 0 || velocity.y != 0:
		animation_tree["parameters/blend_idle_run/blend_amount"] = 1
		move_and_slide()
	else:
		animation_tree["parameters/blend_idle_run/blend_amount"] = 0
		


func hit():
	life_left -= 1
	life_bar.scale.x = life_left / total_life
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
		print("detected");
		target = body


func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("out")
		target = null


func _on_close_enough_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_tree["parameters/idle_hit_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		attack(body)
		

func _on_cooldown_timeout() -> void:
	can_attack = true



@onready var right_arm: Polygon2D = $sprite2D/polygons/right_arm
@onready var right_leg: Polygon2D = $sprite2D/polygons/right_leg
@onready var body: Polygon2D = $sprite2D/polygons/body
@onready var left_leg: Polygon2D = $sprite2D/polygons/left_leg
@onready var left_arm: Polygon2D = $sprite2D/polygons/left_arm
@onready var head: Polygon2D = $sprite2D/polygons/head



func update_assets():
	print("updating")
	right_arm.texture = asset_holder.npc_asset
	right_leg.texture = asset_holder.npc_asset
	body.texture = asset_holder.npc_asset
	left_leg.texture = asset_holder.npc_asset
	left_arm.texture = asset_holder.npc_asset
	head.texture = asset_holder.npc_asset
	pass;
