extends Node2D

@export_category("Lane Settings")
@export var lanes: Array[Area2D]
@export var laneKeyMap: Dictionary[String, Area2D]
@export var laneAudioMap: Dictionary[String, AudioStreamPlayer]
@export var blank: Area2D

@export_category("Chart Settings")
@export var chart: Chart
@export var chartSpeed: float

@onready var hits: float = 0
@onready var misses: float = 0

var laneNotePresent: Dictionary[Area2D, Area2D]

signal reset_chart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lane in lanes:
		laneNotePresent.set(lane, blank)
	connect("reset_chart", chart.reset_chart)
	chart.transform.origin.y = -300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for action in laneKeyMap.keys():
		var lane: Area2D = laneKeyMap.get(action)
		var note: Area2D = laneNotePresent.get(lane)
		if Input.is_action_just_pressed(action):
			laneAudioMap.get(action).play()
			if note != blank:
				print("note hit on {0}".format([lane.name]))
				chart.disable_note(note)
				hits += 1
				print("hits: {0}".format([hits]))
			else:
				print("no note present, missed!")
				misses += 1
				print("misses: {0}".format([misses]))
	
	chart.transform.origin.y += delta * chartSpeed
	
	# quick reset
	if Input.is_action_just_pressed("ui_accept"):
		print("resetting chart!\nhits: {0}\nmisses: {1}\naccuracy: {2}".format([hits, misses, hits/(hits+misses)]))
		hits = 0
		misses = 0
		emit_signal("reset_chart")
		chart.transform.origin.y = -300

# Note enters the input area, so a note is present
func _on_note_area_entered(note: Area2D, lane: Area2D) -> void:
	print("note entered on {0}".format([lane.name]))
	laneNotePresent[lane] = note

# Note exits input area, so a note isn't present
func _on_note_area_exited(note: Area2D, lane: Area2D) -> void:
	print("note exited on {0}".format([lane.name]))
	# We want the player to target the "freshest" note
	if laneNotePresent[lane] == note:
		laneNotePresent[lane] = blank

# Note goes past the input zone & is missed by the player
func _on_miss_zone_entered(note: Area2D) -> void:
	print("note missed")
	chart.disable_note(note)
	misses += 1
	print("misses: {0}".format([misses]))
