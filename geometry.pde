void updateGeometry(){
 

  
  float axisMin = -10;
  float axisMax =  10;
  float axisRange = axisMax - axisMin;
  float delta = axisRange/(resolution);
  float x, y, z;

   for(int k=0; k< resolution; k++){

      for(int j=0; j< resolution; j++){

            for(int i=0; i< resolution; i++){
                x = ((delta*i)+axisMin);
                y = ((delta*j)+axisMin);
                z = ((delta*k)+axisMin);
                int index = i + (j*resolution) + (k*resolution*resolution);

                
                index *= 4;
                positions[index  ] = x;
                positions[index+1] = y;
                positions[index+2] = z;
                positions[index+3] = 1.0f;

                colors[index  ] = x*y;
                colors[index+1] = y*z;
                colors[index+2] = z;
                colors[index+3] = 1.0f;

                vertIsovalues_1[index  ] = x*y;
                vertIsovalues_1[index+1] = y*z;
                vertIsovalues_1[index+2] = z;
                vertIsovalues_1[index+3] = 1.0f;

                float s = delta; 
                vertIsovalues_1[index  ] = isoFunction(x  , y  , z  );
                vertIsovalues_1[index+1] = isoFunction(x+s, y  , z  );
                vertIsovalues_1[index+2] = isoFunction(x+s, y+s, z  );
                vertIsovalues_1[index+3] = isoFunction(x  , y+s, z  );

                vertIsovalues_2[index  ] = isoFunction(x  , y  , z+s);
                vertIsovalues_2[index+1] = isoFunction(x+s, y  , z+s);
                vertIsovalues_2[index+2] = isoFunction(x+s, y+s, z+s);
                vertIsovalues_2[index+3] = isoFunction(x  , y+s, z+s);
            }
        }
    }
    
    posBuffer.rewind();
    posBuffer.put(positions);
    posBuffer.rewind();

    colorBuffer.rewind();
    colorBuffer.put(colors);
    colorBuffer.rewind();

    vertIsovaluesBuffer_1.rewind();
    vertIsovaluesBuffer_1.put(vertIsovalues_1);
    vertIsovaluesBuffer_1.rewind();

    vertIsovaluesBuffer_2.rewind();
    vertIsovaluesBuffer_2.put(vertIsovalues_2);
    vertIsovaluesBuffer_2.rewind();


    printArray(positions);

}

float isoFunction(float x, float y, float z){
        return pow(x, 2) + pow(y, 2) + pow(z, 2) - 100;
}

void generatePositionsArray(int resolution, float axisMin, float axisMax){

    float axisRange = axisMax - axisMin;
    float delta = axisRange/(resolution);
    float x, y, z;
    int index;

    for(int k=0; k< resolution; k++){
        for(int j=0; j< resolution; j++){
            for(int i=0; i< resolution; i++){
                x = ((delta*i)+axisMin);
                y = ((delta*j)+axisMin);
                z = ((delta*k)+axisMin);
                index = i + (j*resolution) + (k*resolution*resolution);
                
                setPositionAtIndex(index, x, y, z);
                setColorAtIndex(index, x, y, z);
                
            }
        }
    }
}

void setColorAtIndex(int index, float x, float y, float z){
    index*=4;
    colors[index  ] = x*y;
    colors[index+1] = y*z;
    colors[index+2] = z;
    colors[index+3] = 1.0f;
}


void setPositionAtIndex(int index, float x, float y, float z){
    index*=4;
    positions[index  ] = x;
    positions[index+1] = y;
    positions[index+2] = z;
    positions[index+3] = 1.0f;
}

PVector getPositionAtIndex(int index){
    index*=4;
    return new PVector( positions[index  ],
                        positions[index+1],
                        positions[index+2]);
}





