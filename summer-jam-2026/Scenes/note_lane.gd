extends Node2D

@export var lanes: Array[Area2D]
@export var note: Area2D
@export var laneKeyMap: Dictionary[String, Area2D]

@export var chart: Node2D
@export var chartSpeed: float

var laneNotePresent: Dictionary[Area2D, bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lane in lanes:
		laneNotePresent.assign({lane: false})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for action in laneKeyMap.keys():
		var lane: Area2D = laneKeyMap.get(action)
		if Input.is_action_just_pressed(action) and laneNotePresent.get(lane):
			print("note hit on {0}".format([lane.name]))
	
	note.transform.origin.y -= delta * 5
	if note.transform.origin.y < -16:
		note.transform.origin.y = 50

func _on_note_area_entered(_area: Area2D, source: Area2D) -> void:
	print("note entered on {0}".format([source.name]))
	laneNotePresent[source] = true

func _on_note_area_exited(_area: Area2D, source: Area2D) -> void:
	print("note exited on {0}".format([source.name]))
	laneNotePresent[source] = false
