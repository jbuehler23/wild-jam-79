shader_type canvas_item;
uniform vec2 A;
uniform vec2 B;
uniform bool bottom;
varying float determ;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	determ = (UV[0]-A[0])*(B[1]-A[1])-(UV[1]-A[1])*(B[0]-A[0]);

	if (determ < 0.0 && bottom){
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}
	if (determ > 0.0 && !bottom){
		COLOR = texture(TEXTURE, UV);
		COLOR.a = 0.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
