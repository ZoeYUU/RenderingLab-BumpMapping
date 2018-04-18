#version 410

// following Anton's code
// https://github.com/capnramses/antons_opengl_tutorials_book/tree/master/20_normal_mapping

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;
layout(location = 2) in vec2 texture_coord;
layout(location = 3) in vec4 vtangent;

uniform mat4 model, view, proj;

out vec4 test_tan;

out vec2 st;
out vec3 view_dir_tan;
out vec3 light_dir_tan;

void main() {
	gl_Position = proj * view * model * vec4 (vertex_position, 1.0);
	st = texture_coord;
	
	test_tan = vtangent;
	
	// in world space 
	vec3 cam_pos_wor = (inverse (view) * vec4 (0.0, 0.0, 0.0, 1.0)).xyz;
	vec3 light_dir_wor = vec3 (0.0, 0.0, -1.0);
	
	// in local space

	vec3 bitangent = cross (vertex_normal, vtangent.xyz) * vtangent.w ;
	
	// transform  camera and light uniforms into local space 
	//alternatively, get viewDir and lightDir first in eye space, like always did
	// then use inverse(view * model) transform them back into local space - where tangent and bitangent are
	// or,  view * model * vec4(tangent), transform them into eye space
	vec3 cam_pos_loc = vec3 (inverse (model) * vec4 (cam_pos_wor, 1.0));
	vec3 light_dir_loc = vec3 (inverse (model) * vec4 (light_dir_wor, 0.0));
	// view _direction_ in local space
	vec3 view_dir_loc = normalize (cam_pos_loc - vertex_position);
	
	//  same as making a 3x3 inverse tangent matrix

	// work out view direction in _tangent space_
	view_dir_tan = vec3 (
		dot (vtangent.xyz, view_dir_loc),
		dot (bitangent, view_dir_loc),
		dot (vertex_normal, view_dir_loc)
	);
	// work out light direction in _tangent space_
	light_dir_tan = vec3 (
		dot (vtangent.xyz, light_dir_loc),
		dot (bitangent, light_dir_loc),
		dot (vertex_normal, light_dir_loc)
	);

}