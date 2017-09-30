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
float[] isoValuesTexture;

float a;

FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;
FloatBuffer textBuffer;

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
int textLoc;
int textureId;

int resolution = 20;

void settings() {
  size(1400, 700, P3D);
  PJOGL.profile = 4;
}

void setup(){

  
  //cam = new PeasyCam(this, 100);
  
 
  //positions = new float[32];
  int size = int(pow(resolution, 3)*4);
  positions = new float[size];
  //colors = new float[32];
  colors = new float[size];
  //indices = new int[12];
  vertIsovalues_1 = new float[size];
  vertIsovalues_2 = new float[size];
  isoValuesTexture = new float[resolution*resolution*resolution];



  //posBuffer = allocateDirectFloatBuffer(32);
  posBuffer = allocateDirectFloatBuffer(size);
  //colorBuffer = allocateDirectFloatBuffer(32);
  colorBuffer = allocateDirectFloatBuffer(size);

  vertIsovaluesBuffer_1 = allocateDirectFloatBuffer(size);
  vertIsovaluesBuffer_2 = allocateDirectFloatBuffer(size);

  textBuffer = allocateDirectFloatBuffer(resolution*resolution*resolution);


  indexBuffer = allocateDirectIntBuffer(12);

  shaderMC = new GeometryShader(this, "PassthrouVert.glsl", "MarchingGeom.glsl", "SimpleFrag.glsl");
  shader(shaderMC);

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL4();

  IntBuffer intBuffer = IntBuffer.allocate(5);  
  gl.glGenBuffers(4, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  //indexVboId = intBuffer.get(2);
  vertIsovaluesVboId_1 = intBuffer.get(2);
  vertIsovaluesVboId_2 = intBuffer.get(3);


  gl.glGenTextures(1, intBuffer);
  textureId = intBuffer.get(4);

  shaderMC.bind();
  posLoc = gl.glGetAttribLocation(shaderMC.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(shaderMC.glProgram, "color");
  vertIsovaluesLoc_1 = gl.glGetAttribLocation(shaderMC.glProgram, "vertIsovalues_1");
  vertIsovaluesLoc_2 = gl.glGetAttribLocation(shaderMC.glProgram, "vertIsovalues_2");

  textLoc = gl.glGetUniformLocation(shaderMC.glProgram, "isoValTex");
  

  shaderMC.unbind();

  endPGL();
  updateGeometry();
  //textBuffer = FloatBuffer.wrap(isoValuesTexture)
}

void draw(){

background(255);

  // Geometry transformations from Processing are automatically passed to the shader
  // as long as the uniforms in the shader have the right names.
  translate(width/2, height/2);
  rotateX(a);
  rotateY(a*2);  
  stroke(100);
  scale(10);
  //updateGeometry();

  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL4();

  shaderMC.bind();
  gl.glEnableVertexAttribArray(posLoc);
  gl.glEnableVertexAttribArray(colorLoc);  
  gl.glEnableVertexAttribArray(vertIsovaluesLoc_1);  
  gl.glEnableVertexAttribArray(vertIsovaluesLoc_2);
 // gl.glUniform1i(textLoc, 0);
  gl.glUniform1i(textLoc, 0);
  gl.glActiveTexture(GL.GL_TEXTURE0);

  gl.glBindTexture(GL3.GL_TEXTURE_3D, textureId);
  gl.glTexParameteri(GL3.GL_TEXTURE_3D, GL3.GL_TEXTURE_MIN_FILTER, GL3.GL_LINEAR);
  gl.glTexParameteri(GL3.GL_TEXTURE_3D, GL3.GL_TEXTURE_MAG_FILTER, GL3.GL_LINEAR);
  gl.glTexParameteri(GL3.GL_TEXTURE_3D, GL3.GL_TEXTURE_WRAP_S, GL3.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL3.GL_TEXTURE_3D, GL3.GL_TEXTURE_WRAP_T, GL3.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL3.GL_TEXTURE_3D, GL3.GL_TEXTURE_WRAP_R, GL3.GL_CLAMP_TO_EDGE);

 /*  gl.glTexParameteri(GL.GL_TEXTURE_3D, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_3D, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_3D, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_3D, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_3D, GL.GL_TEXTURE_WRAP_R, GL.GL_CLAMP_TO_EDGE);
  */
  
  gl.glTexImage3D(GL3.GL_TEXTURE_3D, 0, GL.GL_LUMINANCE, resolution, resolution, resolution, 0, GL.GL_LUMINANCE, GL.GL_UNSIGNED_BYTE, textBuffer);
   
  
  
  // Copy vertex data to VBOs
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(posLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, vertIsovaluesVboId_1);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * vertIsovalues_1.length, vertIsovaluesBuffer_1, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(vertIsovaluesLoc_1, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, vertIsovaluesVboId_2);  
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * vertIsovalues_2.length, vertIsovaluesBuffer_2, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(vertIsovaluesLoc_2, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glDrawArrays(PGL.POINTS, 0, positions.length/4);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);

  // Draw the triangle elements
  /* gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glDrawElements(PGL.POINTS, indices.length, GL.GL_UNSIGNED_INT, 0);
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);     */

  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc); 
  gl.glDisableVertexAttribArray(vertIsovaluesLoc_1); 
  gl.glDisableVertexAttribArray(vertIsovaluesLoc_2); 

  shaderMC.unbind();

  endPGL();

  a += 0.01;
  

}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}