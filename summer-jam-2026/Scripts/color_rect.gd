extends ColorRect

@onready var Audio:AudioStreamPlayer2D = get_tree().get_first_node_in_group("Audio")

func trigger_red_flash():
	# Turn screen red
	material.set_shader_parameter("flash_amount", 1.0)
	
	# Wait for 1 second
	await get_tree().create_timer(1).timeout
	
	# Turn it off
	material.set_shader_parameter("flash_amount", 0.0)


func _on_animal_sliding_blood_spatter() -> void:
	trigger_red_flash()
