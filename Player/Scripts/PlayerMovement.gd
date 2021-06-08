extends KinematicBody2D

const MAX_GRAVITY = 40
const MAX_RUN_SPEED = 400
const MAX_SPRINT_SPEED = 650

#PHYSICS VARIABLES
var UP = Vector2(0 ,-1)
var vel = Vector2(0.0,0.0)
var maxvel = MAX_RUN_SPEED
export(float) var maxFallSpeed = 500.0
export(float) var accel = 20.0
export(float) var gravity = MAX_GRAVITY
export(float) var jumpForce = 900.0

#JUMP LOGISTICS VARIABLES
var canJump = true
var gripOnWall_Left = false
var gripOnWall_Right = false
var canWallJump = true
var isWallJumping = false
var fromWall_Left = false
var fromWall_Right = false
export(float) var gripOnWallVelocity = 200.0

#NODES AND OBJECTS VARIABLES
onready var RayCast_LEFT = $RayCastLEFT
onready var RayCast_LEFT2 = $RayCastLEFT2
onready var RayCast_RIGHT = $RayCastRIGHT
onready var RayCast_RIGHT2 = $RayCastRIGHT2
#onready var RayCast_UP = $RayCasts/RayCast2UP
#onready var RayCast_DOWN = $RayCasts/RayCast2DOWN

#FILES AND ASSETS VARIABLES
var wallSliding_texture = preload("res://Player/Sprites/WallSliding_01.png")

# SIGNALS SIGNALS SIGNALS SIGNALS SIGNALS SIGNALS
signal Player_On_Objective()
signal PlayerDed()

# PARTICLES
var isDead = false
export(PackedScene) var DeathParticles

func _ready():
	$Sprite.visible = true
	isDead = false

########################################################## BEGINING OF _PHYSICS_PROCESS()
# warning-ignore:unused_argument
func _physics_process(delta):
	if isDead:
		return
	
#	COSAS DE LA GRAVEDAD
	if nextToWall():
		vel = Vector2(vel.x, clamp(vel.y, -1000, gripOnWallVelocity))
		vel.y += gravity
	else:
		vel.y += gravity
	
	if vel.y > maxFallSpeed:
		vel.y = maxFallSpeed
	
#	COSAS DE LA VELOCIDAD MÁXIMA
	if Input.is_action_pressed("sprint") and is_on_floor():
		maxvel = MAX_SPRINT_SPEED
	elif is_on_floor() and !Input.is_action_just_pressed("sprint"):
		maxvel = MAX_RUN_SPEED

#	COSAS DEL MOVIMIENTO LATERAL	
	vel.x = clamp(vel.x, -maxvel, maxvel)
	if Input.is_action_pressed("move_right"):
		if is_on_floor():
			$AnimationPlayer.play("Running")
		
		if vel.x < 0:
			vel.x = vel.x / 2
		vel.x += accel
		if $AnimationPlayer.current_animation == "Idle" or $AnimationPlayer.current_animation == "Running":
			$Sprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		if is_on_floor():
			$AnimationPlayer.play("Running")
		
		if vel.x > 0:
			vel.x = vel.x / 2
		vel.x += -accel
		if $AnimationPlayer.current_animation == "Idle" or $AnimationPlayer.current_animation == "Running":
			$Sprite.flip_h = true
	else:
		if is_on_floor():
			vel.x = lerp(vel.x, 0, 0.2)

#	COSAS DEL SALTO
	if Input.is_action_just_pressed("jump") and canJump and is_on_floor():
		$AnimationPlayer.play("Jumping")
		$Sprite.rotation_degrees = 0
		vel.y -= jumpForce
		canJump = false
		canWallJump = false
	
	if Input.is_action_pressed("jump") and nextToWall() and canWallJump:
		canWallJump = false
		isWallJumping = true
		$AnimationPlayer.play("Jumping")
		
		if nextToLeftWall():
			fromWall_Left = true
			fromWall_Right = false
			vel.x += jumpForce * 1.5
			vel.y -= jumpForce / 4
		elif nextToRightWall():
			fromWall_Left = false
			fromWall_Right = true
			vel.x -= jumpForce * 1.5
			vel.y -= jumpForce / 4
		vel.y -= jumpForce
	
#	COSAS DEL SALTO EN LAS PAREDES
	if Input.is_action_pressed("jump") and isWallJumping:
		$AnimationPlayer.play("Jumping")
		if fromWall_Left and !Input.is_action_pressed("move_left"):
			vel.x += accel * 10
		elif fromWall_Right and !Input.is_action_pressed("move_right"):
			vel.x -= accel * 10
		elif fromWall_Left and Input.is_action_pressed("move_left"):
			fromWall_Left = false
			isWallJumping = false
		elif fromWall_Right and Input.is_action_pressed("move_right"):
			fromWall_Right = false
			isWallJumping = false
	
#	RESETEO DEL SALTO EN VARIAS CIRCUNSTANCIAS
	if Input.is_action_just_released("jump"):
		canJump = true
		isWallJumping = false
		fromWall_Left = false
		fromWall_Right = false
		if vel.y < 0:
			vel.y = 0
	
	if is_on_floor():
		if canJump == false:
			$AnimationPlayer.play("Landing")
		canJump = true
		isWallJumping = false
		fromWall_Left = false
		fromWall_Right = false
	if !is_on_floor() and nextToWall() and !Input.is_action_pressed("jump"):
		canWallJump = true
	
#	MOVER TODO JUNTO COMO UN CONJUNTO
	vel = move_and_slide(vel, UP)
	
	
#	COSAS DE LOS SPRITES
	if nextToWall() and !is_on_floor():
#		if gripOnWall_Left:
		if nextToLeftWall():
			$AnimationPlayer.play("WallSliding_Left")
			$Sprite.flip_h = false
		elif nextToRightWall():
			$AnimationPlayer.play("WallSliding_Right")
			$Sprite.flip_h = true
		else:
			return
	
	######## When is jumping and moving to the right
	if $AnimationPlayer.current_animation == "Jumping" and vel.x > 0:
		$Sprite.flip_h = false
		$Sprite.rotation_degrees = 30
	######## When is jumping and moving to the left
	if $AnimationPlayer.current_animation == "Jumping" and vel.x < 0:
		$Sprite.flip_h = true
		$Sprite.rotation_degrees = -30
	####### When is jumping from a wall and is wall sliding still, and moving to the roght
	if !is_on_floor() and !nextToWall() and vel.x < 10 and vel.x > -10:
		$AnimationPlayer.play("Jumping")
	
	if !nextToWall() and is_on_floor() and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		$AnimationPlayer.play("Idle")
	if is_on_floor() and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		$AnimationPlayer.play("Idle")
########################################################## END OF _PHYSICS_PROCESS()


func DeathSequence():
	var dp = DeathParticles.instance()
	$Sprite.visible = false
	isDead = true
	add_child(dp)
	emit_signal("PlayerDed")
#	yield(get_tree().create_timer(3), "timeout")
#	remove_child(dp)
#	RestartPlayer()


func RestartPlayer():
	var startingPosition = get_parent().get_node("PlayerStartingPosition").get_global_position()
	self.global_position = startingPosition
	$Sprite.visible = true
	isDead = false

# RAYCASTS FUNCTIONS
func nextToWall():
	return nextToRightWall() or nextToLeftWall()

func nextToRightWall():
	return RayCast_RIGHT.is_colliding() or RayCast_RIGHT2.is_colliding()

func nextToLeftWall():
	return RayCast_LEFT.is_colliding() or RayCast_LEFT2.is_colliding()

func _input(event):
	if event.is_action_pressed("reset"):
		RestartPlayer()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Idle":
		$AnimationPlayer.play("Idle")

func _on_PlayerArea_body_entered(body):
	if body.is_in_group("Saws"):
		DeathSequence()

func _on_PlayerArea_area_entered(area):
	if area.is_in_group("Objective"):
		emit_signal("Player_On_Objective")

func _on_Laser_PlayerCollision():
	DeathSequence()

func _on_World_PlayerOutOfBounds():
	DeathSequence()

