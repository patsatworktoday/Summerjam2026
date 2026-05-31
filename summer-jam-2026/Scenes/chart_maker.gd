extends Node2D

@export var player: AudioStreamPlayer
@export var laneKeyMap: Dictionary[String, float]
@export var laneAudioMap: Dictionary[String, AudioStreamPlayer]
@export var laneSpriteMap: Dictionary[String, String]
@export var chartSpeed: float
@export var notePS: PackedScene
@export var followCam: Camera2D
@export var chartParent: Node2D
@export var timeLabel: Label

@onready var recording: bool = false
@onready var paused: bool = false

func _ready() -> void:
	player.connect("finished", stop_charting)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeLabel.text = "Paused: {0}\nTime: {1}".format([paused, player.get_playback_position()])
	
	if Input.is_action_just_pressed("ui_accept"):
		if !recording:
			start_charting()
		else:
			if !paused:
				player.stream_paused = true
				paused = true
			else:
				player.stream_paused = false
				paused = false
	
	if recording:
		var dist = -(chartSpeed * player.get_playback_position())
		followCam.transform.origin.y = dist
		for action in laneKeyMap.keys():
			if Input.is_action_just_pressed(action):
				print("keypress for ", action)
				laneAudioMap.get(action).play()
				var newNote: Area2D = notePS.instantiate()
				chartParent.add_child(newNote)
				newNote.owner = chartParent
				newNote.get_child(1).set_animation(laneSpriteMap.get(action))
				newNote.transform.origin = Vector2(laneKeyMap.get(action), dist)
	
	if Input.is_action_just_pressed("ui_cancel"):
		stop_charting()

func start_charting():
	for node in chartParent.get_children():
		if node is Area2D:
			node.free()
	recording = true
	player.play()

func stop_charting() -> void:
	recording = false
	player.stop()
	followCam.transform.origin.y = 0
	save_chart()

func save_chart() -> void:
	var chart = PackedScene.new()
	chart.pack(chartParent)
	ResourceSaver.save(chart, "res://SavedChart.tscn")
	
