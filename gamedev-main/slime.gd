extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000
const HEALTH = 100  # Set the enemy's initial health value

var direction = Vector2.ZERO
var health = HEALTH

# Get the gravity from the OS settings to be synced with RigidBody nodes.


func _physics_process(delta):
	# Apply gravity
	velocity.y += GRAVITY * delta

	# Update the enemy's movement
	move_enemy()

	# Move the enemy
	direction = move_and_slide()

func move_enemy():
	# Implement the enemy's movement logic here.
	# For simplicity, we'll just make the enemy move back and forth horizontally.
	# You can replace this with your own logic.
	if is_on_wall():
		velocity.x *= -1
	

func take_damage(damage_amount):
	# Reduce the enemy's health when it takes damage
	health -= damage_amount

	# Check if the enemy has been defeated
	if health <= 0:
		enemy_defeated()

func enemy_defeated():
	# Implement what happens when the enemy is defeated (e.g., play death animation, drop loot, etc.)
	queue_free()  # Destroy the enemy instancede()
