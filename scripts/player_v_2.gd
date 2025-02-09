class_name Player_v_2
extends CharacterBody2D

@export var asset_holder: Resource

@export var Bullet : PackedScene= preload("res://scenes/bullet.tscn")
@onready var character: Node2D = $character
@onready var sprite_scale = character.scale.x
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var cooldown: Timer = $cooldown
@onready var life_bar: ColorRect = $Control/life_bar
@onready var gun: Polygon2D = $character/gun


#const WALK_SPEED = 360.0
const WALK_SPEED = 360.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0

const States = {
	IDLE = "idle",
	WALK = "walk",
	RUN = "run",
	FLY = "fly",
	FALL = "fall",
	HIT = "hit"
}

var dir_x = 0;
var dir_y = 0;


var blend_amount = 0;
var blend_target = 0;

var can_shoot = true

var life_left = 3
var total_lifes = 3.0

func _ready():
	$AnimationTree.active = true
	life_bar.scale.x = life_left / total_lifes


func _physics_process(delta: float) -> void:
	var i_h := Input.get_axis("move_left", "move_right")
	var i_v :=Input.get_axis("move_up", "move_down")
	if i_h != 0 || i_v != 0:
		dir_x = Input.get_axis("move_left", "move_right")
		dir_y = Input.get_axis("move_up", "move_down")
	
	var direction_hor = i_h * WALK_SPEED
	var direction_ver = i_v * WALK_SPEED
	velocity.x = move_toward(velocity.x, direction_hor, ACCELERATION_SPEED * delta)
	velocity.y = move_toward(velocity.y, direction_ver, ACCELERATION_SPEED * delta)

	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			character.scale.x = 1.0 * sprite_scale
		else:
			character.scale.x = -1.0 * sprite_scale
	
	
	
	var rotation = atan2(dir_y, dir_x)

	if abs(rad_to_deg(rotation)) > 90:
		rotation = rotation - deg_to_rad(180);
		rotation = -rotation
	gun.rotation = (rotation);
		
	
	
	move_and_slide()

	if velocity.x || velocity.y:
		blend_target = 1
	else:
		blend_target = 0
	if blend_target  > blend_amount:
		blend_amount += 0.1
	if blend_target  < blend_amount:
		blend_amount -= 0.1
	blend_amount = max(0, min(1, blend_amount))
	
	animation_tree["parameters/blend_idle_run/blend_amount"] = blend_amount

		
	if abs(velocity.x) > 50:
		animation_tree["parameters/run_timescale/scale"] = abs(velocity.x) / 240
		
	elif abs(velocity.y) > 50:
		animation_tree["parameters/run_timescale/scale"] = abs(velocity.y) / 240
	
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("melee"):
		print("hit")
		animation_tree["parameters/idle_hit_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
func hit():
	life_left -= 1
	life_bar.scale.x = life_left / total_lifes
	print("hitted", life_left / total_lifes, life_left)
	if life_left <= 0:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	pass
	
func shoot():
	if can_shoot:
		var b = Bullet.instantiate()	
		%bullets_group.add_child(b)
		b.find_child("tex").texture = asset_holder.weapon_asset
		var rotation = atan2(dir_y, dir_x)
		b.transform = $character/gun/Muzzle.global_transform
		b.direction = rad_to_deg(rotation) 
		b.rotation = 0
		cooldown.start(1)
		can_shoot = false

func _on_cooldown_timeout() -> void:
	can_shoot = true



@onready var polygons: Node2D = $character/polygons

func update_assets():
	print("updating")
	
	for el in polygons.get_children():
		el.texture = asset_holder.protagonist_asset
	
	gun.texture = asset_holder.weapon_asset
	pass;
