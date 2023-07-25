extends CharacterBody2D

@export var speed = 200
var player_chase = false
var player = null

@export var health_enemy: float = 100
var player_in_attack_zone = false
var can_take_damage = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	deal_with_damage()

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("Walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle")
		
	move_and_slide()
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
		
func deal_with_damage():
	if player_in_attack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health_enemy += -10
			$take_damage_cooldown.start()
			can_take_damage = false
			print("enemy health = ", health_enemy)
			if health_enemy <= 0:
				print("dead")
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true


func _on_areakill_body_exited(body):
	health_enemy += -10
	
