import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;

PShader shaderMC;
PJOGL pgl;
GL3 gl;

float[] positions;
float[] colors;
float[] vertIsovalues_1;
float[] vertIsovalues_2;

float a;
ArrayList<VBO> VBOlist = new ArrayList<VBO>();
int resolution = 20;
VBO posvbo, colorvbo, vert1vbo, vert2vbo;

VBO colorsVBO, positionsVBO, vertIsovaluesBVO_1, vertIsovaluesBVO_2;
float isoValuesArray[];

void settings() {
  size(1400, 700, P3D);
  PJOGL.profile = 4;
}

void setup(){

  
  int size = int(resolution*resolution*resolution) *4;
 

  isoValuesArray = new float[(resolution+1)*(resolution+1)*(resolution+1)];

  shaderMC = new GeometryShader(this, "PassthrouVert.glsl", "TestGeom.glsl", "SimpleFrag.glsl");
  shader(shaderMC);

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL4();

  shaderMC.bind();

  positionsVBO = new VBO(gl, size, shaderMC.glProgram, "position");
  colorsVBO = new VBO(gl, size, shaderMC.glProgram, "color");
  vertIsovaluesBVO_1 = new VBO(gl, size, shaderMC.glProgram, "vertIsovalues_1");
  vertIsovaluesBVO_2 = new VBO(gl, size, shaderMC.glProgram, "vertIsovalues_2");


 
  shaderMC.unbind();

  endPGL();

  

foo();
  
  
  
}

void foo(){
  float delta =  generateVBOsData(resolution, -10, 10);
  fillIsovaluesArray(resolution, -10, delta);
  mapVBOIsovalues(resolution);

  
  positionsVBO.updateBuffer();
  colorsVBO.updateBuffer();
  vertIsovaluesBVO_1.updateBuffer();
  vertIsovaluesBVO_2.updateBuffer();
  printArray(isoValuesArray);
}

void draw(){

background(255);

  // Geometry transformations from Processing are automatically passed to the shader
  // as long as the uniforms in the shader have the right names.
  translate(width/2, height/2);
  rotateX(a);
  rotateY(a*2);  
  scale(10);
 

  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL4();

  shaderMC.bind();
  
  


  positionsVBO.enableVertAttrib(gl,4);
  colorsVBO.enableVertAttrib(gl,4);
  vertIsovaluesBVO_1.enableVertAttrib(gl,4);
  vertIsovaluesBVO_2.enableVertAttrib(gl,4);


  gl.glDrawArrays(PGL.POINTS, 0, positionsVBO.data.length);




  shaderMC.unbind();

  endPGL();

  a += 0.01;
  

}
