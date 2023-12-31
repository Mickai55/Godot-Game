extends CharacterBody3D
# How fast the player moves in meters per second.
@export var speed = 2
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 1

var target_velocity = Vector3.ZERO

var start_time = null
var shootingDelay = 0.2 # 1 / shootingRate == cate proiectile trage pe secunda (aici 5)
var shootedAtTime = 0

var projectile = load('res://projectile.tscn')
	
func _ready():
	start_time = Time.get_unix_time_from_system()
#	add_collision_exception_with(projectile)


func _physics_process(delta):
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		print(collision)
	
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z -= 1
	if Input.is_action_pressed("move_up"):
		direction.z += 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position - direction, Vector3.UP)
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
#	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
#		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
#	else:
#		target_velocity.y = 0
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	var gameTimer = Time.get_unix_time_from_system() - start_time
	if Input.is_action_pressed("shoot"):
		if gameTimer - shootedAtTime > shootingDelay:
			shootedAtTime = gameTimer
			spawnProjectile()
			
		

func spawnProjectile():
	var projectileCopy = projectile.instantiate()
	projectileCopy.position = position
	get_parent().add_child(projectileCopy)

