extends Node2D

@export var lane: Area2D
@export var note: Area2D

var laneNotePresent: Dictionary[Area2D, bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laneNotePresent = {
		self.lane: false
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var inputArr = [
		#Input.is_action_just_pressed("ui_accept")
	#]
	
	if Input.is_action_just_pressed("ui_accept") and laneNotePresent[self.lane]:
		print("wahoo u did it")
		note.transform.origin.y = 50
	
	note.transform.origin.y -= delta * 5
	if note.transform.origin.y < -16:
		note.transform.origin.y = 50


func _on_note_area_entered(_area: Area2D, source: Area2D) -> void:
	print("area entered")
	laneNotePresent[source] = true


func _on_note_area_exited(_area: Area2D, source: Area2D) -> void:
	print("area exited")
	laneNotePresent[source] = false
	
	
	
	
	
	
	
	
	
	
	
