extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@export var damage = 3
@export var inventory = []
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimatedSprite2D

func _ready():
	animation.speed_scale = 1

func _physics_process(delta):
	if (velocity.y > 1 || velocity.y < -1):
		animation.speed_scale = 2
		animation.play("fly")
	elif (velocity.x > 1 || velocity.x < -1):
		animation.speed_scale = 2
		animation.play("run")
	else:
		animation.speed_scale = 1
		animation.play("idle")

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
