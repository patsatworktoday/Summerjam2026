@tool


class_name Chart
extends Node2D

@export_tool_button("Update Array", "Array") var res: Callable = update_array

@export var notes: Array[Area2D]

func reset_chart() -> void:
	for note in notes:
		note.process_mode = Node.PROCESS_MODE_INHERIT

func disable_note(note: Area2D) -> void:
	note.process_mode = Node.PROCESS_MODE_DISABLED

func update_array():
	print("new array")
	for node in get_children():
		if node is Area2D:
			print("adding {0} to array".format([node.name]))
			notes.append(node)
	notify_property_list_changed()
