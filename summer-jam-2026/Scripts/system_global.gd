extends Node



var most_recent_score:float = 0.0

var Player_Scores:Array = [{"name":"Pat","score":-1.0}]

func _ready() -> void:
	if FileAccess.file_exists("user://save"):
		Player_Scores=[]
		print("file loaded")
		LOAD()

func SAVE():
	var save = FileAccess.open("user://save",FileAccess.WRITE)
	save.store_var(Player_Scores)
	save.close()
	print("file saved")

func LOAD():
	for arraything in FileAccess.open("user://save",FileAccess.READ).get_var():
		Player_Scores.append(arraything)
		print(str(arraything) + "arraything")
