extends Control

func start_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/note lane.tscn")

func quit_game() -> void:
	get_tree().quit()
