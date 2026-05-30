shader_type canvas_item;
//uniform vec2 offset1 = vec2(0.1,0.1);
uniform sampler2D noise_tex1:repeat_enable;
uniform sampler2D noise_tex2:repeat_enable;
uniform sampler2D screen_texture:hint_screen_texture, filter_nearest;
uniform float n1_offset = .1;
uniform float n2_offset = .2;
uniform float distortion_strength:hint_range(0.0, .25, 0.01);
uniform float flash_amount:hint_range(0.0,1.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 coords = UV;
	//coords += offset1*TIME;
	vec2 n2_coords = UV + (vec2(n2_offset)*(TIME/10.));
	//n2_coords = vec2(UV.x - ((n2_offset)*(TIME/10.)),UV.y);
	//applying offset time in a specific axis only lets me control which axis the distortion appears to move instance
	// adding offset moves towards 0, subtracting offset moves towards one
	
	vec2 n1_coords = UV + (vec2(n1_offset)*(TIME/10.))*-1.0;
	//n1_coords = vec2(UV.x - ((n1_offset)*(TIME/10.)),UV.y);
	
	vec4 ori_color = texture(screen_texture,SCREEN_UV);
	vec4 n1_color = texture(noise_tex1,cos(n1_coords));
	vec4 n2_color = texture(noise_tex2,sin(n2_coords));
	
	vec4 fin_col = vec4(vec3(n1_color.r*n2_color.r),1.0);
	
	//vec2 offset = vec2(1.,0.);
	//COLOR = ori_color;
	//COLOR = fin_col; //This is two channel distortion
	// Called for every pixel the material is visible on.
	
	//COLOR = mix(ori_color,fin_col,0.2);
	vec4 blue = vec4(1.0,.0,.0,flash_amount);
	//use noise to distort screen uvec2
	vec4 distort_col = texture(screen_texture,SCREEN_UV+(fin_col.r*distortion_strength));
	vec4 distort_colb = vec4(distort_col.r,distort_col.g,distort_col.b,0.0);
	//vec4 distort_col = texture(screen_texture,SCREEN_UV); Sparkly
	//if(fin_col.r>.04){
	COLOR = distort_colb + blue;
	//}
	//else {
		//COLOR = vec4(1.0);
	//}
	//COLOR = n1_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
