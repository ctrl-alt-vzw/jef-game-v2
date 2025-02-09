extends CharacterBody2D
# Keep this in sync with the AnimationTree's state names.
const States = {
	IDLE = "idle",
	WALK = "walk",
	RUN = "run",
	FLY = "fly",
	FALL = "fall",
}

func _ready():
	$AnimationTree.active = true
	$AnimationTree["parameters/state/transition_request"] = States.IDLE
