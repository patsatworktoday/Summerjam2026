shader_type canvas_item;

uniform sampler2D blood_texture : source_color, filter_linear_mipmap;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform float distortion : hint_range(0.0, 5.0) = 0.5;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Distort the screen texture underneath the blood slightly for a wet look
    vec2 wet_uv = SCREEN_UV + (TEXTURE_PIXEL_SIZE * distortion);
    vec4 screen_color = texture(SCREEN_TEXTURE, wet_uv);
    
    // Sample the blood spatter texture
    vec4 blood = texture(blood_texture, UV);
    
    // Apply user-defined opacity to the blood and calculate final alpha
    blood.a *= opacity;
    
    // Blend the blood on top of the distorted screen background
    COLOR = mix(screen_color, blood, blood.a);
}
