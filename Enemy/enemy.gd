extends CharacterBody2D

@export var ACCELERATION : int = 1000
@export var MAX_SPEED : int = 300
@export var FRICTION : int = 1
@export var BULLET_SPEED: int = 500

@onready var player_detection_zone = $PlayerDetectionZone
@onready var delay = $Delay
var bullet = preload("res://Enemy/enemy_bullet.tscn")
var can_fire = true


func _physics_process(delta):
	move(delta)
	move_and_slide()
	var player = player_detection_zone.player
	if player != null:
		var player_direction = global_position.direction_to(player.global_position)
		rotation = player_direction.angle()
		accelerate_toward_point(player.global_position, delta)
		if can_fire:
			delay.start()
			fire()

func move(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func fire():
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

