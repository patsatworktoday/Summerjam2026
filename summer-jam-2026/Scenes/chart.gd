class_name Chart
extends Node2D

@export var notes: Array[Area2D]

func reset_chart() -> void:
	for note in notes:
		note.process_mode = Node.PROCESS_MODE_INHERIT

func disable_note(note: Area2D) -> void:
	note.process_mode = Node.PROCESS_MODE_DISABLED
