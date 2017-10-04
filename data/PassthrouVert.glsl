#version 430

in vec4 position;
in vec4 color;
//in vec4 vertIsovalues_1;
//in vec4 vertIsovalues_2;

in vec3 normal;
 
out VertexData {
  vec4 color;
  vec3 normal;
  //vec4 vertIsovalues_1;
  //vec4 vertIsovalues_2;
} VertexOut;
 
void main() {
  gl_Position = position;
  VertexOut.color = color;
  VertexOut.normal = normal;  
  //VertexOut.vertIsovalues_1 = vertIsovalues_1;
  //VertexOut.vertIsovalues_2 = vertIsovalues_2;

}
