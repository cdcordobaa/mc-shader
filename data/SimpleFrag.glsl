#version 430

in FragData {
  vec4 color;
} FragIn;
uniform sampler2D triTableTex;
out vec4 fragColor;


void main() {
  fragColor = FragIn.color;
  fragColor = texture2D(triTableTex,vec2(85,5));
}

