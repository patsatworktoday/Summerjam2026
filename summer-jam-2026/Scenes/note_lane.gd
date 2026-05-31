extends Node2D

@export_category("Lane Settings")
@export var lanes: Array[Area2D]
@export var laneKeyMap: Dictionary[String, Area2D]
@export var laneAudioMap: Dictionary[String, AudioStreamPlayer]
@export var blank: Area2D

@export_category("Chart Settings")
@export var chart: Chart
@export var chartSpeed: float

@export_category("Music")
@export var musicPlayer: AudioStreamPlayer

@onready var hits: float = 0
@onready var misses: float = 0

var playDelay: Timer
var laneNotePresent: Dictionary[Area2D, Area2D]

signal end_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lane in lanes:
		laneNotePresent.set(lane, blank)
	chart.transform.origin.y = -320
	playDelay = Timer.new()
	add_child(playDelay)
	playDelay.one_shot = true
	playDelay.timeout.connect(musicPlayer.play)
	playDelay.start(5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for action in laneKeyMap.keys():
		var lane: Area2D = laneKeyMap.get(action)
		var note: Area2D = laneNotePresent.get(lane)
		if Input.is_action_just_pressed(action):
			laneAudioMap.get(action).play()
			if note != blank:
				chart.disable_note(note)
				note.get_child(1).play("green")
				hits += 1
				print("hits: {0}".format([hits]))
				update_score()
			else:
				misses += 1
				print("misses: {0}".format([misses]))
				update_score()
	
	chart.transform.origin.y += delta * chartSpeed

# Note enters the input area, so a note is present
func _on_note_area_entered(note: Area2D, lane: Area2D) -> void:
	laneNotePresent[lane] = note

# Note exits input area, so a note isn't present
func _on_note_area_exited(note: Area2D, lane: Area2D) -> void:
	# We want the player to target the "freshest" note
	if laneNotePresent[lane] == note:
		laneNotePresent[lane] = blank

# Note goes past the input zone & is missed by the player
func _on_miss_zone_entered(note: Area2D) -> void:
	chart.disable_note(note)
	misses += 1
	print("misses: {0}".format([misses]))
	update_score()

func end_chart():
	print("ending game")
	end_game.emit()
	
func update_score():
	SystemGlobal.note_score = hits / (hits + misses)
