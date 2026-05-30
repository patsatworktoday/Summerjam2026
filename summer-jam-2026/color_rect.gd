extends ColorRect

func trigger_red_flash():
	# Turn screen red
	material.set_shader_parameter("flash_amount", 1.0)
	
	# Wait for 1 second
	await get_tree().create_timer(0.2).timeout
	
	# Turn it off
	material.set_shader_parameter("flash_amount", 0.0)


func _on_animal_sliding_blood_spatter() -> void:
	trigger_red_flash()
