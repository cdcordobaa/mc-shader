import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;

import peasy.*;
PeasyCam cam;

PShader shaderMC;

PJOGL pgl;
GL3 gl;

float[] positions;
float[] colors;
int[] indices;

float[] vertIsovalues_1;
float[] vertIsovalues_2;

float a;

ArrayList<VBO> VBOlist = new ArrayList<VBO>();

FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;

FloatBuffer vertIsovaluesBuffer_1;
FloatBuffer vertIsovaluesBuffer_2;

int posVboId;
int colorVboId;
int indexVboId;
int vertIsovaluesVboId_1;
int vertIsovaluesVboId_2;


int posLoc; 
int colorLoc;
int vertIsovaluesLoc_1;
int vertIsovaluesLoc_2;


int resolution = 20;
VBO posvbo, colorvbo, vert1vbo, vert2vbo;

void settings() {
  size(1400, 700, P3D);
  PJOGL.profile = 4;
}

void setup(){

  
  int size = int(pow(resolution, 3)*4);
  positions = new float[size];  
  colors = new float[size];
  vertIsovalues_1 = new float[size];
  vertIsovalues_2 = new float[size];

  shaderMC = new GeometryShader(this, "PassthrouVert.glsl", "TestGeom.glsl", "SimpleFrag.glsl");
  shader(shaderMC);

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL4();

  shaderMC.bind();

  posvbo = new VBO(gl, positions, shaderMC.glProgram, "position");
  colorvbo = new VBO(gl, colors, shaderMC.glProgram, "color");
  vert1vbo = new VBO(gl, vertIsovalues_1, shaderMC.glProgram, "vertIsovalues_1");
  vert2vbo = new VBO(gl, vertIsovalues_2, shaderMC.glProgram, "vertIsovalues_2");

  shaderMC.unbind();

  endPGL();

  updateGeometry();
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
  
  
  posvbo.bindToShader(gl,positions.length,4);
  colorvbo.bindToShader(gl,positions.length,4);
  vert1vbo.bindToShader(gl,positions.length,4);
  vert2vbo.bindToShader(gl,positions.length,4);

  gl.glDrawArrays(PGL.POINTS, 0, positions.length);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);

  gl.glDisableVertexAttribArray(vert1vbo.glDataLoc);



  shaderMC.unbind();

  endPGL();

  a += 0.01;
  

}
