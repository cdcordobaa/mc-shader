void updateGeometry() {
  // Vertex 1
  positions[0] = -200;
  positions[1] = -200;
  positions[2] = 0;
  positions[3] = 1;

  colors[0] = 1.0f;
  colors[1] = 0.0f;
  colors[2] = 0.0f;
  colors[3] = 1.0f;

  // Vertex 2
  positions[4] = +200;
  positions[5] = -200;
  positions[6] = 0;
  positions[7] = 1;

  colors[4] = 1.0f;
  colors[5] = 1.0f;
  colors[6] = 0.0f;
  colors[7] = 1.0f;

  // Vertex 3
  positions[8] = -200;
  positions[9] = +200;
  positions[10] = 0;
  positions[11] = 1;    

  colors[8] = 0.0f;
  colors[9] = 1.0f;
  colors[10] = 0.0f;
  colors[11] = 1.0f;

  // Vertex 4
  positions[12] = +200;
  positions[13] = +200;
  positions[14] = 0;
  positions[15] = 1;

  colors[12] = 0.0f;
  colors[13] = 1.0f;
  colors[14] = 1.0f;
  colors[15] = 1.0f; 

  // Vertex 5
  positions[16] = -200;
  positions[17] = -200 * cos(HALF_PI);
  positions[18] = -200 * sin(HALF_PI);
  positions[19] = 1;

  colors[16] = 0.0f;
  colors[17] = 0.0f;
  colors[18] = 1.0f;
  colors[19] = 1.0f;

  // Vertex 6
  positions[20] = +200;
  positions[21] = -200 * cos(HALF_PI);
  positions[22] = -200 * sin(HALF_PI);
  positions[23] = 1;

  colors[20] = 1.0f;
  colors[21] = 0.0f;
  colors[22] = 1.0f;
  colors[23] = 1.0f;

  // Vertex 7
  positions[24] = -200;
  positions[25] = +200 * cos(HALF_PI);
  positions[26] = +200 * sin(HALF_PI);
  positions[27] = 1;    

  colors[24] = 0.0f;
  colors[25] = 0.0f;
  colors[26] = 0.0f;
  colors[27] = 1.0f;

  // Vertex 8
  positions[28] = +200;
  positions[29] = +200 * cos(HALF_PI);
  positions[30] = +200 * sin(HALF_PI);
  positions[31] = 1;

  colors[28] = 1.0f;
  colors[29] = 1.0f;
  colors[30] = 1.1f;
  colors[31] = 1.0f; 

  // Triangle 1
  indices[0] = 0;
  indices[1] = 1;
  indices[2] = 2;

  // Triangle 2
  indices[3] = 2;
  indices[4] = 3;
  indices[5] = 1;

  // Triangle 3
  indices[6] = 4;
  indices[7] = 5;
  indices[8] = 6;

  // Triangle 4
  indices[9] = 6;
  indices[10] = 7;
  indices[11] = 5;  

  posBuffer.rewind();
  posBuffer.put(positions);
  posBuffer.rewind();

  colorBuffer.rewind();
  colorBuffer.put(colors);
  colorBuffer.rewind();

  indexBuffer.rewind();
  indexBuffer.put(indices);
  indexBuffer.rewind();
}  