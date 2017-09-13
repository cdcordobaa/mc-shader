#version 330

layout (points) in;
layout (triangle_strip, max_vertices = 128) out;
 
uniform mat4 transformMatrix;
uniform mat4 modelviewMatrix;
uniform mat3 normalMatrix;
 
in VertexData {
  vec4 color;
  vec3 normal;
} VertexIn[];
 
out FragData {
  vec4 color;
} FragOut;
 
float size = 50.0;

 void createVertex(vec3 offset){
   vec4 actualOffset = vec4(offset*size, 0.0);
   vec4 worldPosition = gl_in[0].gl_Position + actualOffset;
   gl_Position = transformMatrix * worldPosition;
   FragOut.color = vec4(0,0,255,1);
   EmitVertex();
 }

 
void main() {
  

	createVertex(vec3(-1.0, 1.0, 1.0));
	createVertex(vec3(-1.0, -1.0, 1.0));
	createVertex(vec3(1.0, 1.0, 1.0));
	createVertex(vec3(1.0, -1.0, 1.0));
	
	EndPrimitive();
	
	createVertex(vec3(1.0, 1.0, 1.0));
	createVertex(vec3(1.0, -1.0, 1.0));
	createVertex(vec3(1.0, 1.0, -1.0));
	createVertex(vec3(1.0, -1.0, -1.0));
	
	EndPrimitive();
	
	createVertex(vec3(1.0, 1.0, -1.0));
	createVertex(vec3(1.0, -1.0, -1.0));
	createVertex(vec3(-1.0, 1.0, -1.0));
	createVertex(vec3(-1.0, -1.0, -1.0));
	
	EndPrimitive();
	
	createVertex(vec3(-1.0, 1.0, -1.0));
	createVertex(vec3(-1.0, -1.0, -1.0));
	createVertex(vec3(-1.0, 1.0, 1.0));
	createVertex(vec3(-1.0, -1.0, 1.0));
	
	EndPrimitive();
	
	createVertex(vec3(1.0, 1.0, 1.0));
	createVertex(vec3(1.0, 1.0, -1.0));
	createVertex(vec3(-1.0, 1.0, 1.0));
	createVertex(vec3(-1.0, 1.0, -1.0));
	
	EndPrimitive();
	
	createVertex(vec3(-1.0, -1.0, 1.0));
	createVertex(vec3(-1.0, -1.0, -1.0));
	createVertex(vec3(1.0, -1.0, 1.0));
	createVertex(vec3(1.0, -1.0, -1.0));
	
	EndPrimitive();
	

}