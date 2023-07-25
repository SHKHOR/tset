extends CharacterBody2D
var frame = 0
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
@export var health : float = 10000
var player_alive = true

#var attack_in_progress = false

@export var nSPEED : float = 300.0
@export var JUMP_VELOCITY : float = -250

@export var friction: float = 10
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_cooldown = $Dash_Cooldown


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction :Vector2 = Vector2.ZERO
var was_in_air : bool = false
var can_dash = true


func _physics_process(delta):
	
	enemy_attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("player has died")
		self.queue_free()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
		
		if was_in_air == true:
			land()
			
		was_in_air = false
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print_debug("Jump")
		jump()
	direction = Input.get_vector("left","right","up","down") 
	if direction:
		velocity.x = direction.x * nSPEED
	else:
		velocity.x = move_toward(velocity.x, 0, nSPEED)
#	Handle Attack
	if Input.is_action_just_pressed("Dash") and can_dash :
		
		var mouse_direction = get_local_mouse_position().normalized()
		velocity = Vector2(1500 * mouse_direction.x, 500 * mouse_direction.y)
		can_dash = false
		await get_tree().create_timer(1).timeout
		can_dash  = true
	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	
			if direction.x != 0:
				animated_sprite.play("Walking Animation")
			else:
				animated_sprite.play("Idle Animation")
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
func jump():
	velocity.y = JUMP_VELOCITY
	animated_sprite.play("Jump Start Animation")
	animation_locked = true

func land():
	animated_sprite.play("Jump End Animation")
	animation_locked = true

func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "Jump End Animation"):
		animation_locked = false
	elif (animated_sprite.animation == "Attack End Animation"):
		animation_locked = false
func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

	
	

	



	
