// Credits: https://thebookofshaders.com/08/

mat2 rotate2d(float _angle){
	return mat2(
		vec2(cos(_angle), -sin(_angle)),
		vec2(sin(_angle), cos(_angle)));
}