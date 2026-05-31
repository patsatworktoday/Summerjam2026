extends Node2D

var score:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	SystemGlobal.note_score = 0
	SystemGlobal.animal_score = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		game_over()
	
func game_over():
	SystemGlobal.most_recent_score = SystemGlobal.animal_score * (1.0+SystemGlobal.note_score*4.0)
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	
