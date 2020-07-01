extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500
export var ROLL_SPEED = 120


#state machine
enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

#Animation
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var SwordHitbox = $HitboxPivot/SwordHitbox
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	SwordHitbox.knockBack_vector = roll_vector

#Movement function
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.knockBack_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
		
		
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state(delta):
	animationState.travel("Attack")
	
func move():
	 velocity = move_and_slide(velocity)

func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE
