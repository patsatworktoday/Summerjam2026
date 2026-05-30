extends Node2D

@export_category("Lane Settings")
@export var lanes: Array[Area2D]
@export var laneKeyMap: Dictionary[String, Area2D]
@export var blank: Area2D

@export_category("Chart Settings")
@export var chart: Node2D
@export var chartSpeed: float

@onready var hits: int = 0
@onready var misses: int = 0

var laneNotePresent: Dictionary[Area2D, Area2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lane in lanes:
		laneNotePresent.set(lane, blank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for action in laneKeyMap.keys():
		var lane: Area2D = laneKeyMap.get(action)
		var note: Area2D = laneNotePresent.get(lane)
		if Input.is_action_just_pressed(action) and note != blank:
			print("note hit on {0}".format([lane.name]))
			note.process_mode = Node.PROCESS_MODE_DISABLED
			hits += 1
			print("hits: {0}".format([hits]))
	
	chart.transform.origin.y -= delta * chartSpeed
	
	if Input.is_action_just_pressed("ui_accept"):
		chart.transform.origin.y = 300

# Note enters the input area, so a note is present
func _on_note_area_entered(area: Area2D, source: Area2D) -> void:
	print("note entered on {0}".format([source.name]))
	laneNotePresent[source] = area

# Note exits input area, so a note isn't present
func _on_note_area_exited(area: Area2D, source: Area2D) -> void:
	print("note exited on {0}".format([source.name]))
	# We want the player to target the "freshest" note
	if laneNotePresent[source] == area:
		laneNotePresent[source] = blank

# Note goes past the input zone & is missed by the player
func _on_miss_zone_entered(area: Area2D) -> void:
	print("note missed")
	area.process_mode = Node.PROCESS_MODE_DISABLED
	misses += 1
	print("misses: {0}".format([misses]))
