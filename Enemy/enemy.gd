extends CharacterBody2D

@export var ACCELERATION : int = 1000
@export var MAX_SPEED : int = 300
@export var FRICTION : int = 1
@export var BULLET_SPEED : int = 500
@export var WANDER_RANGE : int = 50

@onready var player_detection_zone = $PlayerDetectionZone
@onready var delay = $Delay
@onready var wander_delay = $WanderDelay

var bullet = preload("res://Enemy/enemy_bullet.tscn")
var can_fire = true
var can_move = true

enum { WANDER, CHASE }
var state = WANDER

func _physics_process(delta):
	move(delta)
	
	match state:
		WANDER:
			seek_player()
		CHASE:
			chase_player(delta)

func move(delta):
	if can_move and player_detection_zone.player == null:
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = random_direction * WANDER_RANGE
		wander_delay.start()
		can_move = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
		
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func chase_player(delta):
	var player = player_detection_zone.player
	if player != null:
		var player_direction = global_position.direction_to(player.global_position)
		rotation = player_direction.angle()
		accelerate_toward_point(player.global_position, delta)
		if can_fire:
			fire()

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func fire():
	delay.start()
	var bullet_instantiate = bullet.instantiate()
	bullet_instantiate.global_position = get_global_position()
	bullet_instantiate.rotation_degrees = rotation_degrees
	bullet_instantiate.apply_impulse(Vector2(BULLET_SPEED,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instantiate)
	can_fire = false

func _on_hitbox_body_entered(body):
	if "Bullet" in body.name:
		SoundPlayer.play_sound(SoundPlayer.ENEMY_DEATH)
		queue_free()

func _on_delay_timeout():
	can_fire = true

func _on_wander_delay_timeout():
	can_move = true
