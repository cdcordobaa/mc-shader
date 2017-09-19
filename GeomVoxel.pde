import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;

import peasy.*;
PeasyCam cam;

PShader geoTest;

PJOGL pgl;
GL3 gl;

float[] positions;
float[] colors;
int[] indices;
float a;

FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;

int posVboId;
int colorVboId;
int indexVboId;


int posLoc; 
int colorLoc;

void settings() {
  size(1400, 700, P3D);
  PJOGL.profile = 4;
}

void setup(){

  
  cam = new PeasyCam(this, 100);
  
 
  positions = new float[32];
  colors = new float[32];
  indices = new int[12];

  posBuffer = allocateDirectFloatBuffer(32);
  colorBuffer = allocateDirectFloatBuffer(32); 
  indexBuffer = allocateDirectIntBuffer(12);

  geoTest = new GeometryShader(this, "PassthrouVert.glsl", "TestGeom.glsl", "SimpleFrag.glsl");
  shader(geoTest);

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL3();

  IntBuffer intBuffer = IntBuffer.allocate(3);  
  gl.glGenBuffers(3, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  indexVboId = intBuffer.get(2);

  geoTest.bind();
  posLoc = gl.glGetAttribLocation(geoTest.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(geoTest.glProgram, "color");
  geoTest.unbind();

  endPGL();

}

void draw(){

background(255);

  // Geometry transformations from Processing are automatically passed to the shader
  // as long as the uniforms in the shader have the right names.
  translate(width/2, height/2);
  //rotateX(a);
  //rotateY(a*2);  
  stroke(100);
  updateGeometry();

  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL4();

  geoTest.bind();
  gl.glEnableVertexAttribArray(posLoc);
  gl.glEnableVertexAttribArray(colorLoc);  

  // Copy vertex data to VBOs
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(posLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);

  // Draw the triangle elements
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glDrawElements(PGL.POINTS, indices.length, GL.GL_UNSIGNED_INT, 0);
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);    

  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc); 
  geoTest.unbind();

  endPGL();

  a += 0.01;
  

}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}