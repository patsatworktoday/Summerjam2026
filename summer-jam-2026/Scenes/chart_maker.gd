extends Node2D

@export var player: AudioStreamPlayer
@export var laneKeyMap: Dictionary[String, float]
@export var chartSpeed: float
@export var notePS: PackedScene
@export var followCam: Camera2D
@export var chartParent: Node2D

@onready var recording: bool = false

func _ready() -> void:
	player.connect("finished", stop_charting)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_charting()
	
	if recording:
		for action in laneKeyMap.keys():
			if Input.is_action_just_pressed(action):
				print("keypress for ", action)
				var dist = -(chartSpeed * player.get_playback_position())
				var newNote: Area2D = notePS.instantiate()
				chartParent.add_child(newNote)
				newNote.owner = chartParent
				newNote.transform.origin = Vector2(laneKeyMap.get(action), dist)
				followCam.transform.origin.y = dist
	
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
	
