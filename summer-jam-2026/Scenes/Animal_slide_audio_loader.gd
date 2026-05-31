extends AudioStreamPlayer2D

@export var stream_array:Array[AudioStream]

func play_track(id:int)-> void:
	stop()
	stream = stream_array[id]
	play()
