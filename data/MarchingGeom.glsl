#version 430

layout (points) in;
layout (triangle_strip, max_vertices = 128) out;
 
uniform mat4 transformMatrix;
uniform mat4 modelviewMatrix;
uniform mat3 normalMatrix;
uniform float size;

//light
const vec3 lightDirection = normalize(vec3(0.4, -10, 0.8));
 
in VertexData {
  vec4 color;
  vec3 normal;
  vec4 vertIsovalues_1;
  vec4 vertIsovalues_2;
} VertexIn[];
 
out FragData {
  vec4 color;
} FragOut;
 
int edgeTable[256] = {
  0x0  , 0x109, 0x203, 0x30a, 0x406, 0x50f, 0x605, 0x70c,
  0x80c, 0x905, 0xa0f, 0xb06, 0xc0a, 0xd03, 0xe09, 0xf00,
  0x190, 0x99 , 0x393, 0x29a, 0x596, 0x49f, 0x795, 0x69c,
  0x99c, 0x895, 0xb9f, 0xa96, 0xd9a, 0xc93, 0xf99, 0xe90,
  0x230, 0x339, 0x33 , 0x13a, 0x636, 0x73f, 0x435, 0x53c,
  0xa3c, 0xb35, 0x83f, 0x936, 0xe3a, 0xf33, 0xc39, 0xd30,
  0x3a0, 0x2a9, 0x1a3, 0xaa , 0x7a6, 0x6af, 0x5a5, 0x4ac,
  0xbac, 0xaa5, 0x9af, 0x8a6, 0xfaa, 0xea3, 0xda9, 0xca0,
  0x460, 0x569, 0x663, 0x76a, 0x66 , 0x16f, 0x265, 0x36c,
  0xc6c, 0xd65, 0xe6f, 0xf66, 0x86a, 0x963, 0xa69, 0xb60,
  0x5f0, 0x4f9, 0x7f3, 0x6fa, 0x1f6, 0xff , 0x3f5, 0x2fc,
  0xdfc, 0xcf5, 0xfff, 0xef6, 0x9fa, 0x8f3, 0xbf9, 0xaf0,
  0x650, 0x759, 0x453, 0x55a, 0x256, 0x35f, 0x55 , 0x15c,
  0xe5c, 0xf55, 0xc5f, 0xd56, 0xa5a, 0xb53, 0x859, 0x950,
  0x7c0, 0x6c9, 0x5c3, 0x4ca, 0x3c6, 0x2cf, 0x1c5, 0xcc ,
  0xfcc, 0xec5, 0xdcf, 0xcc6, 0xbca, 0xac3, 0x9c9, 0x8c0,
  0x8c0, 0x9c9, 0xac3, 0xbca, 0xcc6, 0xdcf, 0xec5, 0xfcc,
  0xcc , 0x1c5, 0x2cf, 0x3c6, 0x4ca, 0x5c3, 0x6c9, 0x7c0,
  0x950, 0x859, 0xb53, 0xa5a, 0xd56, 0xc5f, 0xf55, 0xe5c,
  0x15c, 0x55 , 0x35f, 0x256, 0x55a, 0x453, 0x759, 0x650,
  0xaf0, 0xbf9, 0x8f3, 0x9fa, 0xef6, 0xfff, 0xcf5, 0xdfc,
  0x2fc, 0x3f5, 0xff , 0x1f6, 0x6fa, 0x7f3, 0x4f9, 0x5f0,
  0xb60, 0xa69, 0x963, 0x86a, 0xf66, 0xe6f, 0xd65, 0xc6c,
  0x36c, 0x265, 0x16f, 0x66 , 0x76a, 0x663, 0x569, 0x460,
  0xca0, 0xda9, 0xea3, 0xfaa, 0x8a6, 0x9af, 0xaa5, 0xbac,
  0x4ac, 0x5a5, 0x6af, 0x7a6, 0xaa , 0x1a3, 0x2a9, 0x3a0,
  0xd30, 0xc39, 0xf33, 0xe3a, 0x936, 0x83f, 0xb35, 0xa3c,
  0x53c, 0x435, 0x73f, 0x636, 0x13a, 0x33 , 0x339, 0x230,
  0xe90, 0xf99, 0xc93, 0xd9a, 0xa96, 0xb9f, 0x895, 0x99c,
  0x69c, 0x795, 0x49f, 0x596, 0x29a, 0x393, 0x99 , 0x190,
  0xf00, 0xe09, 0xd03, 0xc0a, 0xb06, 0xa0f, 0x905, 0x80c,
  0x70c, 0x605, 0x50f, 0x406, 0x30a, 0x203, 0x109, 0x0   };


int triTable_transpose[16][256] = {
      {-1,	0,	0,	1,	1,	0,	9,	2,	3,	0,	1,	1,	3,	0,	3,	9,	4,	4,	0,	4,	1,	3,	9,	2,	8,	11,	9,	4,	3,	1,	4,	4,	9,	9,	0,	8,	1,	3,	5,	2,	9,	0,	0,	2,	10,	4,	5,	5,	9,	9,	0,	1,	9,	10,	8,	2,	7,	9,	2,	11,	9,	5,	11,	11,	10,	0,	9,	1,	1,	1,	9,	5,	2,	11,	0,	5,	6,	0,	3,	6,	5,	4,	1,	10,	6,	1,	8,	7,	3,	5,	0,	9,	8,	5,	0,	6,	10,	4,	10,	8,	1,	3,	0,	8,	10,	0,	3,	6,	9,	8,	3,	6,	7,	0,	10,	10,	1,	2,	7,	7,	2,	2,	1,	11,	8,	0,	7,	7,	7,	3,	0,	8,	10,	1,	2,	6,	7,	7,	2,	1,	10,	10,	0,	7,	6,	3,	8,	9,	6,	1,	4,	10,	8,	0,	1,	1,	8,	10,	4,	10,	4,	0,	5,	11,	9,	6,	7,	3,	7,	9,	3,	6,	9,	1,	4,	7,	6,	3,	0,	6,	1,	0,	11,	6,	5,	9,	1,	1,	1,	10,	0,	10,	11,	11,	5,	10,	11,	0,	9,	7,	2,	8,	9,	9,	1,	0,	9,	9,	5,	5,	0,	10,	2,	0,	0,	9,	2,	5,	3,	5,	8,	0,	8,	9,	4,	0,	1,	3,	4,	9,	11,	11,	2,	9,	3,	1,	4,	4,	4,	4,	9,	3,	0,	3,	1,	3,	0,	3,	2,	9,	2,	1,	1,	0,	0,	-1},
      {-1,	8,	1,	8,	2,	8,	2,	8,	11,	11,	9,	11,	10,	10,	9,	8,	7,	3,	1,	1,	2,	4,	2,	10,	4,	4,	0,	7,	10,	11,	7,	7,	5,	5,	5,	5,	2,	0,	2,	10,	5,	11,	5,	1,	3,	9,	4,	4,	7,	3,	7,	5,	7,	1,	0,	10,	9,	5,	3,	2,	5,	7,	10,	10,	6,	8,	0,	8,	6,	6,	6,	9,	3,	0,	1,	10,	3,	8,	11,	5,	10,	3,	9,	6,	1,	2,	4,	3,	11,	10,	1,	2,	4,	1,	5,	5,	4,	10,	0,	3,	4,	0,	2,	3,	4,	8,	11,	4,	6,	11,	11,	4,	10,	7,	6,	6,	2,	6,	8,	3,	3,	0,	8,	2,	9,	9,	8,	11,	6,	0,	1,	1,	1,	2,	9,	11,	2,	0,	7,	6,	7,	7,	3,	6,	8,	6,	6,	4,	8,	2,	11,	9,	2,	4,	9,	9,	1,	1,	6,	9,	9,	8,	0,	7,	5,	11,	6,	4,	2,	5,	6,	2,	5,	6,	0,	6,	9,	6,	11,	11,	2,	11,	8,	11,	8,	5,	5,	5,	3,	1,	3,	5,	5,	5,	11,	7,	1,	8,	7,	5,	5,	2,	0,	8,	3,	8,	0,	8,	8,	0,	1,	11,	5,	4,	2,	4,	5,	10,	10,	10,	4,	4,	4,	4,	11,	8,	10,	1,	11,	7,	7,	7,	9,	10,	7,	10,	9,	9,	0,	8,	10,	0,	1,	1,	2,	0,	2,	2,	3,	10,	3,	10,	3,	9,	3,	-1},
      {-1,	3,	9,	3,	10,	3,	10,	3,	2,	2,	0,	2,	1,	1,	0,	10,	8,	0,	9,	9,	10,	7,	10,	9,	7,	7,	1,	11,	1,	10,	8,	11,	4,	4,	4,	4,	10,	8,	10,	5,	4,	2,	4,	5,	11,	5,	0,	8,	8,	0,	8,	3,	8,	2,	2,	5,	5,	7,	11,	1,	8,	0,	0,	5,	5,	3,	1,	3,	5,	5,	5,	8,	11,	8,	9,	6,	11,	11,	6,	9,	6,	0,	0,	5,	2,	5,	7,	9,	2,	6,	9,	1,	7,	11,	9,	9,	9,	6,	1,	1,	9,	8,	4,	2,	9,	2,	2,	1,	4,	1,	6,	8,	6,	3,	7,	7,	6,	9,	0,	2,	11,	7,	0,	1,	6,	1,	0,	6,	11,	8,	9,	9,	2,	10,	0,	7,	3,	8,	6,	2,	6,	6,	7,	10,	4,	11,	11,	6,	4,	10,	8,	3,	3,	2,	0,	4,	3,	0,	3,	4,	5,	3,	1,	6,	4,	7,	11,	8,	3,	4,	2,	8,	4,	10,	10,	10,	5,	11,	8,	3,	10,	3,	5,	3,	9,	6,	8,	6,	6,	0,	8,	6,	10,	10,	7,	5,	2,	3,	5,	2,	10,	0,	1,	2,	5,	7,	3,	7,	4,	4,	9,	4,	1,	11,	5,	5,	10,	2,	2,	2,	5,	5,	5,	5,	7,	3,	11,	4,	7,	4,	4,	4,	10,	7,	10,	2,	1,	1,	3,	7,	8,	9,	10,	10,	11,	9,	11,	11,	8,	2,	8,	2,	8,	1,	8,	-1},
      {-1,	-1,	-1,	9,	-1,	1,	0,	2,	-1,	8,	2,	1,	11,	0,	3,	10,	-1,	7,	8,	4,	8,	3,	9,	2,	3,	11,	8,	9,	3,	1,	9,	4,	-1,	0,	1,	8,	9,	1,	5,	3,	2,	0,	0,	2,	10,	0,	5,	5,	5,	9,	0,	3,	9,	9,	8,	2,	7,	9,	0,	11,	8,	5,	11,	7,	-1,	5,	5,	1,	2,	1,	9,	5,	10,	11,	2,	1,	6,	0,	0,	6,	4,	4,	5,	1,	6,	5,	9,	7,	7,	4,	4,	9,	3,	5,	0,	6,	6,	4,	10,	8,	1,	1,	4,	8,	10,	2,	0,	6,	9,	8,	3,	11,	7,	0,	1,	10,	1,	2,	7,	6,	10,	2,	1,	11,	8,	11,	7,	-1,	-1,	11,	11,	8,	6,	3,	2,	2,	6,	7,	2,	1,	10,	1,	0,	7,	11,	3,	8,	9,	6,	3,	4,	10,	8,	4,	2,	1,	8,	10,	4,	6,	7,	4,	5,	8,	10,	1,	5,	3,	7,	0,	3,	6,	10,	1,	4,	7,	6,	0,	0,	6,	9,	0,	11,	6,	5,	9,	1,	2,	1,	10,	5,	-1,	7,	11,	5,	10,	11,	1,	9,	7,	2,	8,	5,	9,	3,	0,	9,	5,	5,	5,	8,	10,	2,	0,	0,	2,	3,	5,	3,	5,	8,	1,	8,	-1,	4,	4,	1,	3,	9,	9,	11,	11,	2,	9,	3,	8,	4,	4,	7,	-1,	10,	3,	0,	11,	1,	3,	8,	-1,	2,	0,	2,	-1,	9,	-1,	-1,	-1},
      {-1,	-1,	-1,	8,	-1,	2,	2,	10,	-1,	11,	3,	9,	10,	8,	11,	8,	-1,	3,	4,	7,	4,	0,	0,	9,	11,	2,	4,	4,	11,	4,	0,	11,	-1,	8,	5,	3,	5,	2,	4,	2,	3,	8,	1,	5,	1,	8,	0,	8,	7,	5,	1,	5,	5,	5,	2,	5,	8,	7,	1,	1,	5,	0,	0,	11,	-1,	10,	10,	9,	6,	2,	0,	8,	6,	2,	3,	9,	5,	11,	3,	9,	7,	7,	10,	9,	5,	2,	0,	9,	8,	7,	7,	11,	11,	11,	6,	9,	4,	9,	6,	1,	2,	2,	2,	2,	6,	8,	1,	1,	3,	1,	6,	6,	8,	10,	10,	7,	6,	9,	0,	7,	6,	7,	7,	1,	6,	6,	0,	-1,	-1,	7,	7,	3,	11,	0,	10,	10,	2,	6,	3,	8,	1,	7,	7,	10,	8,	0,	4,	6,	11,	0,	6,	3,	4,	6,	3,	4,	6,	0,	3,	10,	6,	9,	4,	3,	1,	2,	4,	5,	6,	8,	7,	8,	1,	7,	10,	10,	11,	6,	5,	3,	5,	6,	5,	3,	2,	6,	8,	1,	6,	0,	6,	-1,	5,	7,	10,	11,	7,	2,	2,	2,	3,	5,	10,	2,	7,	7,	3,	9,	10,	11,	4,	4,	8,	11,	5,	11,	5,	2,	5,	2,	5,	0,	5,	-1,	9,	9,	11,	4,	11,	11,	4,	4,	7,	7,	10,	7,	1,	1,	4,	-1,	11,	9,	10,	3,	11,	9,	0,	-1,	8,	9,	8,	-1,	1,	-1,	-1,	-1},
      {-1,	-1,	-1,	1,	-1,	10,	9,	8,	-1,	0,	11,	11,	3,	10,	9,	11,	-1,	4,	7,	1,	7,	4,	2,	7,	2,	4,	7,	11,	10,	11,	11,	9,	-1,	3,	0,	5,	4,	10,	2,	5,	11,	11,	5,	8,	3,	1,	11,	10,	9,	3,	7,	7,	7,	0,	5,	3,	9,	2,	8,	7,	7,	9,	3,	5,	-1,	6,	6,	8,	1,	6,	6,	2,	5,	0,	11,	2,	3,	5,	6,	11,	8,	3,	6,	7,	1,	6,	5,	4,	4,	2,	8,	2,	5,	6,	5,	11,	10,	10,	0,	6,	4,	9,	6,	4,	4,	11,	6,	10,	6,	0,	0,	8,	10,	7,	7,	1,	8,	1,	6,	2,	8,	11,	8,	7,	7,	7,	6,	-1,	-1,	6,	6,	1,	7,	8,	9,	3,	7,	0,	7,	6,	7,	10,	10,	8,	6,	6,	6,	3,	8,	11,	11,	2,	2,	2,	4,	2,	1,	6,	8,	4,	11,	5,	0,	4,	2,	10,	10,	4,	2,	6,	6,	7,	6,	6,	5,	8,	9,	3,	11,	5,	11,	11,	6,	5,	8,	0,	0,	6,	10,	6,	10,	-1,	11,	5,	11,	7,	1,	7,	7,	11,	5,	2,	3,	1,	5,	1,	5,	7,	8,	0,	10,	5,	5,	3,	9,	3,	2,	4,	10,	4,	3,	5,	3,	-1,	11,	7,	4,	8,	4,	7,	2,	2,	9,	4,	2,	4,	7,	7,	3,	-1,	8,	11,	8,	10,	9,	11,	11,	-1,	10,	2,	10,	-1,	8,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	10,	-1,	-1,	-1,	9,	-1,	8,	11,	-1,	-1,	-1,	-1,	7,	-1,	1,	8,	2,	-1,	2,	2,	9,	7,	1,	9,	9,	-1,	-1,	-1,	3,	-1,	4,	4,	3,	-1,	4,	2,	2,	9,	8,	5,	10,	-1,	5,	1,	-1,	10,	5,	8,	3,	3,	9,	1,	7,	10,	7,	10,	-1,	-1,	-1,	-1,	5,	-1,	3,	0,	5,	-1,	10,	5,	9,	5,	0,	0,	11,	-1,	6,	8,	1,	4,	3,	0,	3,	10,	4,	2,	9,	3,	1,	0,	4,	-1,	0,	6,	8,	2,	2,	-1,	4,	11,	4,	0,	4,	9,	11,	0,	-1,	8,	0,	1,	1,	1,	6,	6,	-1,	10,	0,	1,	10,	9,	-1,	3,	-1,	-1,	-1,	-1,	11,	-1,	6,	6,	10,	-1,	6,	0,	1,	1,	1,	0,	8,	-1,	0,	9,	9,	2,	0,	0,	9,	4,	-1,	2,	2,	8,	6,	6,	-1,	-1,	11,	7,	3,	7,	0,	4,	3,	5,	0,	1,	2,	1,	1,	0,	5,	11,	0,	0,	5,	9,	0,	8,	2,	5,	0,	5,	-1,	3,	9,	-1,	-1,	-1,	8,	1,	9,	7,	1,	9,	5,	3,	8,	5,	8,	-1,	1,	5,	-1,	10,	5,	8,	11,	2,	4,	2,	-1,	3,	4,	3,	1,	3,	-1,	9,	-1,	9,	9,	1,	1,	9,	9,	2,	8,	2,	10,	7,	-1,	7,	0,	-1,	-1,	-1,	11,	8,	-1,	9,	1,	-1,	-1,	10,	-1,	0,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	8,	-1,	11,	10,	-1,	-1,	-1,	-1,	3,	-1,	2,	4,	7,	-1,	0,	3,	11,	8,	0,	11,	11,	-1,	-1,	-1,	1,	-1,	9,	0,	5,	-1,	9,	3,	8,	5,	10,	11,	8,	-1,	7,	5,	-1,	1,	3,	5,	5,	11,	2,	7,	1,	1,	11,	5,	-1,	-1,	-1,	-1,	10,	-1,	0,	2,	2,	-1,	6,	10,	11,	1,	5,	6,	9,	-1,	5,	4,	7,	7,	0,	6,	2,	6,	2,	3,	4,	5,	0,	3,	7,	-1,	8,	4,	6,	6,	4,	-1,	2,	2,	9,	6,	8,	1,	6,	6,	-1,	9,	9,	7,	7,	8,	7,	0,	-1,	8,	9,	10,	6,	1,	-1,	11,	-1,	-1,	-1,	-1,	7,	-1,	11,	11,	8,	-1,	2,	1,	9,	3,	8,	10,	10,	-1,	4,	0,	3,	10,	6,	2,	4,	6,	-1,	4,	4,	4,	0,	10,	-1,	-1,	7,	6,	5,	6,	8,	2,	2,	4,	6,	5,	1,	7,	0,	3,	4,	8,	5,	1,	3,	11,	9,	0,	10,	6,	6,	6,	-1,	8,	5,	-1,	-1,	-1,	3,	9,	8,	5,	7,	0,	9,	7,	7,	3,	7,	-1,	7,	3,	-1,	11,	10,	10,	3,	11,	5,	11,	-1,	4,	2,	8,	9,	5,	-1,	0,	-1,	10,	11,	4,	10,	2,	1,	4,	3,	3,	2,	4,	-1,	1,	8,	-1,	-1,	-1,	9,	10,	-1,	11,	2,	-1,	-1,	8,	-1,	1,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	11,	-1,	10,	9,	-1,	-1,	-1,	-1,	1,	-1,	10,	7,	3,	-1,	4,	11,	2,	4,	4,	10,	10,	-1,	-1,	-1,	5,	-1,	5,	2,	4,	-1,	5,	11,	11,	4,	1,	10,	11,	-1,	3,	7,	-1,	2,	0,	7,	7,	2,	0,	8,	5,	3,	0,	0,	-1,	-1,	-1,	-1,	6,	-1,	8,	6,	6,	-1,	5,	6,	2,	3,	1,	5,	8,	-1,	10,	7,	3,	8,	4,	5,	9,	5,	0,	11,	11,	1,	11,	6,	9,	-1,	3,	0,	4,	4,	9,	-1,	6,	3,	10,	4,	1,	3,	1,	4,	-1,	10,	10,	8,	3,	9,	9,	2,	-1,	9,	7,	7,	1,	6,	-1,	0,	-1,	-1,	-1,	-1,	6,	-1,	7,	7,	3,	-1,	0,	9,	8,	7,	7,	9,	9,	-1,	6,	1,	1,	1,	11,	9,	3,	2,	-1,	6,	6,	6,	4,	3,	-1,	-1,	6,	11,	4,	11,	3,	10,	5,	9,	2,	0,	8,	6,	7,	10,	10,	9,	6,	5,	1,	8,	6,	5,	3,	2,	2,	8,	-1,	6,	0,	-1,	-1,	-1,	0,	0,	1,	1,	5,	2,	2,	5,	5,	7,	2,	-1,	5,	7,	-1,	8,	11,	11,	4,	8,	11,	5,	-1,	5,	0,	5,	2,	1,	-1,	5,	-1,	11,	7,	0,	4,	11,	11,	0,	4,	7,	7,	10,	-1,	3,	1,	-1,	-1,	-1,	10,	11,	-1,	8,	9,	-1,	-1,	9,	-1,	8,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	7,	-1,	-1,	-1,	9,	-1,	7,	11,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	-1,	-1,	4,	-1,	8,	11,	-1,	-1,	-1,	-1,	-1,	-1,	5,	10,	-1,	-1,	2,	1,	-1,	10,	1,	8,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	-1,	-1,	9,	-1,	5,	0,	-1,	-1,	-1,	-1,	7,	-1,	3,	0,	5,	-1,	2,	5,	7,	5,	7,	11,	7,	-1,	-1,	-1,	6,	-1,	2,	-1,	-1,	-1,	4,	6,	2,	11,	9,	-1,	-1,	-1,	6,	1,	-1,	8,	0,	-1,	-1,	8,	6,	6,	6,	11,	-1,	11,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	10,	-1,	-1,	-1,	8,	-1,	1,	6,	-1,	-1,	-1,	-1,	11,	-1,	0,	2,	11,	-1,	-1,	4,	-1,	6,	-1,	0,	-1,	-1,	-1,	-1,	3,	-1,	4,	4,	10,	-1,	6,	5,	4,	1,	8,	6,	4,	-1,	0,	5,	-1,	11,	5,	10,	10,	3,	-1,	3,	-1,	5,	5,	-1,	-1,	-1,	-1,	-1,	8,	-1,	7,	2,	3,	-1,	10,	3,	10,	-1,	-1,	-1,	-1,	-1,	11,	10,	9,	4,	2,	4,	-1,	3,	-1,	4,	9,	-1,	-1,	0,	-1,	-1,	9,	7,	7,	9,	2,	-1,	3,	7,	8,	1,	-1,	-1,	8,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	2,	-1,	-1,	-1,	-1,	1,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	2,	-1,	11,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	4,	-1,	-1,	-1,	8,	-1,	11,	0,	-1,	-1,	-1,	-1,	-1,	-1,	7,	5,	-1,	-1,	7,	5,	-1,	3,	0,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	2,	-1,	-1,	-1,	8,	-1,	11,	5,	-1,	-1,	-1,	-1,	9,	-1,	4,	2,	9,	-1,	7,	10,	11,	11,	11,	6,	11,	-1,	-1,	-1,	1,	-1,	6,	-1,	-1,	-1,	10,	1,	1,	6,	1,	-1,	-1,	-1,	7,	8,	-1,	6,	9,	-1,	-1,	6,	7,	7,	7,	6,	-1,	6,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	7,	-1,	0,	10,	-1,	-1,	-1,	-1,	3,	-1,	4,	10,	3,	-1,	-1,	3,	-1,	10,	-1,	3,	-1,	-1,	-1,	-1,	1,	-1,	9,	0,	5,	-1,	8,	4,	8,	3,	7,	10,	8,	-1,	9,	6,	-1,	5,	6,	5,	5,	8,	-1,	8,	-1,	6,	6,	-1,	-1,	-1,	-1,	-1,	3,	-1,	2,	11,	2,	-1,	2,	10,	2,	-1,	-1,	-1,	-1,	-1,	3,	4,	4,	5,	11,	5,	-1,	8,	-1,	5,	4,	-1,	-1,	3,	-1,	-1,	10,	4,	4,	1,	11,	-1,	2,	4,	7,	10,	-1,	-1,	7,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	11,	-1,	-1,	-1,	-1,	10,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	4,	-1,	-1,	-1,	1,	-1,	4,	3,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	5,	-1,	10,	3,	-1,	-1,	-1,	-1,	-1,	-1,	3,	2,	-1,	-1,	11,	7,	-1,	11,	10,	7,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	11,	-1,	6,	9,	-1,	-1,	-1,	-1,	4,	-1,	7,	6,	6,	-1,	11,	6,	4,	6,	4,	3,	9,	-1,	-1,	-1,	10,	-1,	4,	-1,	-1,	-1,	6,	10,	11,	3,	4,	-1,	-1,	-1,	10,	0,	-1,	7,	3,	-1,	-1,	7,	10,	10,	1,	3,	-1,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	6,	-1,	8,	7,	-1,	-1,	-1,	-1,	6,	-1,	6,	9,	6,	-1,	-1,	8,	-1,	1,	-1,	9,	-1,	-1,	-1,	-1,	5,	-1,	5,	2,	2,	-1,	7,	0,	5,	7,	0,	7,	10,	-1,	5,	11,	-1,	6,	9,	2,	3,	2,	-1,	2,	-1,	9,	0,	-1,	-1,	-1,	-1,	-1,	1,	-1,	11,	7,	8,	-1,	5,	2,	5,	-1,	-1,	-1,	-1,	-1,	0,	5,	1,	8,	1,	8,	-1,	4,	-1,	8,	2,	-1,	-1,	5,	-1,	-1,	11,	11,	11,	2,	1,	-1,	4,	9,	0,	0,	-1,	-1,	1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	11,	5,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	2,	-1,	-1,	-1,	5,	-1,	0,	8,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	6,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	7,	-1,	-1,	-1,	9,	2,	-1,	1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	4,	-1,	-1,	-1,	-1,	-1,	-1,	10,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	11,	-1,	-1,	-1,	1,	-1,	9,	3,	-1,	-1,	-1,	-1,	-1,	-1,	1,	0,	-1,	-1,	-1,	6,	-1,	8,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	7,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	5,	11,	-1,	-1,	-1,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	10,	-1,	0,	-1,	-1,	-1,	2,	4,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	10,	7,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	6,	-1,	-1,	-1,	10,	-1,	4,	4,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	11,	-1,	4,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	-1,	-1,	10,	3,	-1,	3,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	6,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	7,	-1,	-1,	-1,	5,	-1,	5,	7,	-1,	-1,	-1,	-1,	-1,	-1,	2,	2,	-1,	-1,	-1,	2,	-1,	9,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	8,	-1,	-1,	-1,	5,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	1,	-1,	1,	8,	-1,	-1,	-1,	1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	11,	-1,	8,	-1,	-1,	-1,	0,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	0,	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	6,	-1,	11,	7,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	1,	-1,	1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	9,	-1,	-1,	-1,	7,	11,	-1,	6,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	-1,	-1,	-1,	-1,	-1,	3,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	6,	-1,	-1,	-1,	8,	-1,	4,	10,	-1,	-1,	-1,	-1,	-1,	-1,	10,	5,	-1,	-1,	-1,	8,	-1,	6,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	2,	-1,	-1,	-1,	2,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	4,	-1,	11,	5,	-1,	-1,	-1,	9,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	4,	-1,	3,	-1,	-1,	-1,	7,	10,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1},
      {-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1}};


void createVertex(vec3 offset, float brightness){
vec4 actualOffset = vec4(offset*size, 0.0);
vec4 worldPosition = gl_in[0].gl_Position + actualOffset;
gl_Position = transformMatrix * worldPosition;
FragOut.color = VertexIn[0].color /*vec4(255,0,255,1)*/ * brightness;
EmitVertex();
}

vec3 generateNormal(vec3 uv, vec3 uw){
  return normalize(cross(uv, uw));
}
 
void createTriangle(vec3 u, vec3 v, vec3 w){

  vec3 triangle_normal = generateNormal(v-u, w-u);
  float brightness = max(dot(lightDirection, triangle_normal), 0.1);

  createVertex(u, brightness);
  createVertex(v, brightness);
  createVertex(w, brightness);
  EndPrimitive(); 

}

void renderCase(int cubeindex, vec3 vertlist[12]){
 
 int u,v,w;

 if(triTable_transpose[0][cubeindex] != -1){
      u = triTable_transpose[0][cubeindex];  
      v = triTable_transpose[1][cubeindex];
      w = triTable_transpose[2][cubeindex];

      createTriangle(vertlist[u], vertlist[v], vertlist[w]);
      
 }

 if(triTable_transpose[3][cubeindex] != -1){
      u = triTable_transpose[3][cubeindex];  
      v = triTable_transpose[4][cubeindex];
      w = triTable_transpose[5][cubeindex];
      createTriangle(vertlist[u], vertlist[v], vertlist[w]);
 }

 if(triTable_transpose[6][cubeindex] != -1){
      u = triTable_transpose[6][cubeindex];  
      v = triTable_transpose[7][cubeindex];
      w = triTable_transpose[8][cubeindex];
      createTriangle(vertlist[u], vertlist[v], vertlist[w]);
 }

 if(triTable_transpose[9][cubeindex] != -1){
      u = triTable_transpose[9][cubeindex];  
      v = triTable_transpose[10][cubeindex];
      w = triTable_transpose[11][cubeindex];
      createTriangle(vertlist[u], vertlist[v], vertlist[w]);
 }

 if(triTable_transpose[12][cubeindex] != -1){
      u = triTable_transpose[12][cubeindex];  
      v = triTable_transpose[13][cubeindex];
      w = triTable_transpose[14][cubeindex];
      createTriangle(vertlist[u], vertlist[v], vertlist[w]);
 }

}

vec3 midPoint(vec3 p1, vec3 p2){
   return (p1 + p2)/2;
}

float getIsovalue(int index){
      if(index < 4)
            return VertexIn[0].vertIsovalues_1[index];
      else 
            return VertexIn[0].vertIsovalues_2[index%4];
}

float getIsovalue1(int index){
            return 0;
            //return VertexIn[0].vertIsovalues_1[index];
}
float getIsovalue2(int index){
            return 1;
            //return VertexIn[0].vertIsovalues_2[index%4];
}

vec3 vertexInterp(const float isolevel, vec3 v0, float l0, vec3 v1, float l1){ 
  return mix(v0, v1, (isolevel-l0)/(l1-l0)); 
}

 void main() {
   
  float isolevel = 0.5;
  int cubeindex = 0;

  vec4 isovalue1 = vec4(0,0,0,0);//VertexIn[0].vertIsovalues_1;
  vec4 isovalue2 = vec4(VertexIn[0].vertIsovalues_2);
  
  if (isovalue1[0] < isolevel) cubeindex |= 1;
  if (isovalue1[1] < isolevel) cubeindex |= 2;
  if (isovalue1[2] < isolevel) cubeindex |= 4;
  if (isovalue1[3] < isolevel) cubeindex |= 8;
  if (isovalue2[0] < isolevel) cubeindex |= 16;
  if (isovalue2[1] < isolevel) cubeindex |= 32;
  if (isovalue2[2] < isolevel) cubeindex |= 64;
  if (isovalue2[3] < isolevel) cubeindex |= 128;

  //cubeindex = 172;
    
  vec3 voxelVertices[8];
  vec3 vertlist[12]; 

  voxelVertices[0] = vec3(0.0, 0.0, 0.0);
  voxelVertices[1] = vec3(1.0, 0.0, 0.0);
  voxelVertices[2] = vec3(1.0, 1.0, 0.0);
  voxelVertices[3] = vec3(0.0, 1.0, 0.0);

  voxelVertices[4] = vec3(0.0, 0.0, 1.0);
  voxelVertices[5] = vec3(1.0, 0.0, 1.0);
  voxelVertices[6] = vec3(1.0, 1.0, 1.0);
  voxelVertices[7] = vec3(0.0, 1.0, 1.0);

/*
  //if ( (edgeTable[cubeindex] & 1) !=0 )
        vertlist[0] =  midPoint(voxelVertices[0], voxelVertices[1]);

  //if ( (edgeTable[cubeindex] & 2) !=0 )
        vertlist[1] =  midPoint(voxelVertices[1], voxelVertices[2]);

  //if ( (edgeTable[cubeindex] & 4) !=0 )
        vertlist[2] =  midPoint(voxelVertices[2], voxelVertices[3]);

  //if ( (edgeTable[cubeindex] & 8) !=0 )
        vertlist[3] =  midPoint(voxelVertices[3], voxelVertices[0]);


  //if ( (edgeTable[cubeindex] & 16) !=0 )
        vertlist[4] =  midPoint(voxelVertices[4], voxelVertices[5]);

  //if ( (edgeTable[cubeindex] & 32) !=0 )
        vertlist[5] =  midPoint(voxelVertices[5], voxelVertices[6]);

  //if ( (edgeTable[cubeindex] & 64) !=0 )
        vertlist[6] =  midPoint(voxelVertices[6], voxelVertices[7]);

  //if ( (edgeTable[cubeindex] & 128) !=0 )
        vertlist[7] =  midPoint(voxelVertices[7], voxelVertices[4]);

  
  //if ( (edgeTable[cubeindex] & 256) !=0 )
        vertlist[8] =  midPoint(voxelVertices[0], voxelVertices[4]);

  //if ( (edgeTable[cubeindex] & 512) !=0 )
        vertlist[9] =  midPoint(voxelVertices[1], voxelVertices[5]);

  //if ( (edgeTable[cubeindex] & 1024) !=0 )
        vertlist[10] =  midPoint(voxelVertices[2], voxelVertices[6]);

  //if ( (edgeTable[cubeindex] & 2048) !=0 )
        vertlist[11] =  midPoint(voxelVertices[3], voxelVertices[7]);

*/        
/* 
vertlist[0] =  vertexInterp(isolevel, voxelVertices[0], isovalue1(0), voxelVertices[1], isovalue1(1));
vertlist[1] =  vertexInterp(isolevel, voxelVertices[1], isovalue1(1), voxelVertices[2], isovalue1(2));
vertlist[2] =  vertexInterp(isolevel, voxelVertices[2], isovalue1(2), voxelVertices[3], isovalue1(3));
vertlist[3] =  vertexInterp(isolevel, voxelVertices[3], isovalue1(3), voxelVertices[0], isovalue1(0));
vertlist[4] =  vertexInterp(isolevel, voxelVertices[4], isovalue2(4), voxelVertices[5], isovalue2(5));
vertlist[5] =  vertexInterp(isolevel, voxelVertices[5], isovalue2(5), voxelVertices[6], isovalue2(6));
vertlist[6] =  vertexInterp(isolevel, voxelVertices[6], isovalue2(6), voxelVertices[7], isovalue2(7));
vertlist[7] =  vertexInterp(isolevel, voxelVertices[7], isovalue2(7), voxelVertices[4], isovalue2(4));  
vertlist[8] =  vertexInterp(isolevel, voxelVertices[0], isovalue1(0), voxelVertices[4], isovalue2(4));
vertlist[9] =  vertexInterp(isolevel, voxelVertices[1], isovalue1(1), voxelVertices[5], isovalue2(5));
vertlist[10] =  vertexInterp(isolevel, voxelVertices[2], isovalue1(2), voxelVertices[6], isovalue2(6));
vertlist[11] =  vertexInterp(isolevel, voxelVertices[3], isovalue1(3), voxelVertices[7], isovalue2(7));
 */
 
  for(int i=0; i<4; i++){
        vertlist[i] = vertexInterp(isolevel, voxelVertices[i], isovalue1[i], voxelVertices[(i+1)%4], isovalue1[(i+1)%4]);  
        vertlist[i+4] = vertexInterp(isolevel, voxelVertices[i+4], isovalue2[i], voxelVertices[(i+5)%4 + 4], isovalue2[(i+5)%4]);
        vertlist[i+8] = vertexInterp(isolevel, voxelVertices[i], isovalue1[i], voxelVertices[i+4], isovalue2[i]);
  }

/*    for(int i=0; i<4; i++){
        vertlist[i] = midPoint(voxelVertices[i], voxelVertices[(i+1)%4]);  
        vertlist[i+4] = midPoint(voxelVertices[i+4], voxelVertices[(i+5)%4 + 4]);
        vertlist[i+8] = midPoint(voxelVertices[i], voxelVertices[i+4]);
  }
 */

  renderCase(cubeindex, vertlist);

}



