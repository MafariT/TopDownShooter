extends Node

const PLAYER_GUN = preload("res://Music and Sound/PlayerGun.wav")
const PLAYER_DEATH = preload("res://Music and Sound/PlayerDeath.wav")
const ENEMY_DEATH = preload("res://Music and Sound/EnemyDeath.wav")

@onready var audio_player = $AudioPlayer

func play_sound(sound):
	for audioStreamPlayer in  audio_player.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
