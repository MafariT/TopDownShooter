extends CharacterBody2D

@export var ACCELERATION : int  = 2000
@export var MAX_SPEED : int = 350
@export var FRICTION : int = 500
@export var BULLET_SPEED : int = 750

@onready var fire_delay = $FireDelay

var bullet = preload("res://Player/bullet.tscn")
var is_can_fire = true


func _physics_process(delta):
	move(delta)
	look_at(get_global_mouse_position())
	fire()

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
func fire():
	if Input.is_action_pressed("LMB") and is_can_fire:
		fire_delay.start()
		is_can_fire = false
		SoundPlayer.play_sound(SoundPlayer.PLAYER_GUN)
		var bullet_instantiate = bullet.instantiate()
		bullet_instantiate.global_position = get_global_position()
		bullet_instantiate.rotation_degrees = rotation_degrees
		bullet_instantiate.apply_impulse(Vector2(BULLET_SPEED,0).rotated(rotation))
		get_tree().get_root().call_deferred("add_child", bullet_instantiate)

func death():
	SoundPlayer.play_sound(SoundPlayer.PLAYER_DEATH)
	get_tree().reload_current_scene()

func _on_hit_box_body_entered(body):
	if "Bullet" and "Enemy" in body.name:
		death()

func _on_fire_delay_timeout():
	is_can_fire = true

