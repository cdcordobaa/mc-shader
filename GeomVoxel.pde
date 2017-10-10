import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL3;

PShader shaderMC;
PJOGL pgl;
GL3 gl;

static int stride = 4;
int resolution = 10;
float a;


ArrayList<VBO> VBOlist = new ArrayList<VBO>();
VBO colorsVBO, positionsVBO, vertIsovaluesBVO_1, vertIsovaluesBVO_2;
float isoValuesArray[];
PVector[] pCloud;

void settings() {
  size(1400, 700, P3D);
  PJOGL.profile = 3;
}

void setup(){
  frameRate(1000);
  int size = int(resolution*resolution*resolution) *4;
  isoValuesArray = new float[(resolution+1)*(resolution+1)*(resolution+1)];
  pCloud = randomPoints(1, -20, 20);

  shaderMC = new GeometryShader(this, "PassthrouVert.glsl", "MarchingGeom.glsl", "SimpleFrag.glsl");
  shader(shaderMC);
  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL3();
  shaderMC.bind();

  positionsVBO = new VBO(gl, size, shaderMC.glProgram, "position");
  colorsVBO = new VBO(gl, size, shaderMC.glProgram, "color");
  vertIsovaluesBVO_1 = new VBO(gl, size, shaderMC.glProgram, "vertIsovalues_1");
  vertIsovaluesBVO_2 = new VBO(gl, size, shaderMC.glProgram, "vertIsovalues_2");

  shaderMC.unbind();
  endPGL();

  VBOlist.add(positionsVBO);
  VBOlist.add(colorsVBO);
  VBOlist.add(vertIsovaluesBVO_1);
  VBOlist.add(vertIsovaluesBVO_2);
  updateData();
  //printArray(pCloud);
  //printArray(isoValuesArray);
}

void updateData(){
  float delta =  generateVBOsData(resolution, -30, 30);
  fillIsovaluesArray(resolution, -30, delta);
  mapVBOIsovalues(resolution);
  shaderMC.set("size", delta);  
  for(VBO vbo: VBOlist){

    vbo.updateBuffer();
    println("data");
    //printArray(vbo.data);
  }
    
}

void draw(){
  background(255);
  // Geometry transformations from Processing are automatically passed to the shader
  // as long as the uniforms in the shader have the right names.

  translate(width/2, height/2);
  //rotateX(a);
  rotateY(a*2);  
  scale(5);
  glBlock();
  a += 0.01;
  println(frameRate);
}


void glBlock(){
  pgl = (PJOGL) beginPGL();  
  gl = pgl.gl.getGL4();    
  shaderMC.bind();
    for(VBO vbo: VBOlist)
      vbo.enableVertAttrib(gl,stride);

    gl.glDrawArrays(PGL.POINTS, 0, positionsVBO.data.length/4);

    for(VBO vbo: VBOlist)
      vbo.disableVertAttrib(gl);
      
  shaderMC.unbind();
  endPGL();
}

PVector[] randomPoints(int numPoints, float min, float max){

  PVector[] pointsCloud = new PVector[numPoints];
  for(int i=0; i<numPoints; i++){
      float xr=random(min,max);
      float yr=random(min,max);
      float zr=random(min,max);            
      pointsCloud[i] = new PVector( xr, yr, zr );
  }  
  return pointsCloud;
}