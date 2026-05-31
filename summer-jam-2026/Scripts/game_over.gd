extends Node2D

@onready var Thanks:RichTextLabel = $RichTextLabel
@onready var GetName:Popup = $Popup
var Player_name:String

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if  SystemGlobal.most_recent_score > 0.0:
		#print("hello" + str(SystemGlobal.most_recent_score))
		GetName.popup_centered_clamped()
	write_leaderboard()

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenees/testingcombined.tscn")


func _on_title_pressed() -> void:
	SystemGlobal.most_recent_score = 0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_line_edit_text_submitted(new_text: String) -> void:
	GetName.visible = false
	update_name(new_text)
	
func update_name(string:String):
	Player_name = string
	SystemGlobal.Player_Scores.append({"name":Player_name,"score":SystemGlobal.most_recent_score})
	SystemGlobal.Player_Scores.sort_custom(func(a,b):return a["score"]>b["score"])
	write_leaderboard()
	
func write_leaderboard():
	var thank_string:String = "Thanks for playing\n\n\tLeaderboard\n\n\tName\t|\tScore\t\n"
	var score_string:String = " \t%s\t|\t%f\t\n"
	for entry in SystemGlobal.Player_Scores:
		var append_string:String
		append_string = score_string % [entry["name"],entry["score"]]
		#print(append_string)
		thank_string = thank_string + append_string
		
	print(str(SystemGlobal.Player_Scores) + "write leaderboard")
	SystemGlobal.SAVE()
	Thanks.text = thank_string


	
