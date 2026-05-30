shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Get the base screen color
    COLOR = mix(vec4(0.0),vec4(1.0,0.0,0.0,1.0),flash_amount);

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
