class_name Player
extends CharacterBody2D

@export var Bullet : PackedScene= preload("res://bullet.tscn")
@onready var sprite = $Sprite2D
@onready var sprite_scale = sprite.scale.x


const WALK_SPEED = 600.0
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

func _ready():
	$AnimationTree.active = true


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
			sprite.scale.x = 1.0 * sprite_scale
		else:
			sprite.scale.x = -1.0 * sprite_scale

	move_and_slide()

	# After applying our motion, update our animation to match.

	if abs(velocity.x) > 50:
		$AnimationTree["parameters/state/transition_request"] = States.RUN
		$AnimationTree["parameters/run_timescale/scale"] = abs(velocity.x) / 100
		
	elif abs(velocity.y) > 50:
		$AnimationTree["parameters/state/transition_request"] = States.RUN
		$AnimationTree["parameters/run_timescale/scale"] = abs(velocity.y) / 100
	elif velocity.x:
		$AnimationTree["parameters/state/transition_request"] = States.WALK
		$AnimationTree["parameters/walk_timescale/scale"] = abs(velocity.x) / 24
	elif velocity.y:
		$AnimationTree["parameters/state/transition_request"] = States.WALK
		$AnimationTree["parameters/walk_timescale/scale"] = abs(velocity.y) / 24
	else:
		$AnimationTree["parameters/state/transition_request"] = States.IDLE
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("melee"):
		print("hit")
		#$AnimationTree["parameters/hit/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
	#print(position)
	#else:
		#if velocity.y > 0:
			#$AnimationTree["parameters/state/transition_request"] = States.FALL
		#else:
			#$AnimationTree["parameters/state/transition_request"] = States.FLY

		
func shoot():
	var b = Bullet.instantiate()	
	owner.add_child(b)
	var rotation = atan2(dir_y, dir_x)
	b.transform = $Muzzle.global_transform
	b.direction = rad_to_deg(rotation) 
	b.rotation = 0
