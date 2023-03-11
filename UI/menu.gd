extends Control



func _on_start_pressed():
	get_tree().change_scene_to_file("res://World/Level.tscn")


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
