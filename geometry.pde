float generateVBOsData(int resolution, float axisMin, float axisMax){

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
    return delta;
}

void fillIsovaluesArray(int resolution, float min, float delta){
    float x, y, z;
    int index;
    for(int k=0; k< resolution+1; k++){
        for(int j=0; j< resolution+1; j++){
            for(int i=0; i< resolution+1; i++){
                x = ((delta*i)+min);
                y = ((delta*j)+min);
                z = ((delta*k)+min);
                index = i + (j*resolution) + (k*resolution*resolution);
                isoValuesArray[index] = getVertIsovalue(x, y, z);
            }
        }
    }
}

void mapVBOIsovalues(int resolution){
    int index;
    for(int k=0; k< resolution; k++){
        for(int j=0; j< resolution; j++){
            for(int i=0; i< resolution; i++){
                index = i + (j*resolution) + (k*resolution*resolution);                
                vertIsovaluesBVO_1.data[index*4  ] = getIsoValueAtIJK(i  , j  , k  , resolution);
                vertIsovaluesBVO_1.data[index*4+1] = getIsoValueAtIJK(i+1, j  , k  , resolution);
                vertIsovaluesBVO_1.data[index*4+2] = getIsoValueAtIJK(i+1, j+1, k  , resolution);
                vertIsovaluesBVO_1.data[index*4+3] = getIsoValueAtIJK(i  , j+1, k  , resolution);

                vertIsovaluesBVO_2.data[index*4  ] = getIsoValueAtIJK(i  , j  , k+1, resolution);
                vertIsovaluesBVO_2.data[index*4+1] = getIsoValueAtIJK(i+1, j  , k+1, resolution);
                vertIsovaluesBVO_2.data[index*4+2] = getIsoValueAtIJK(i+1, j+1, k+1, resolution);
                vertIsovaluesBVO_2.data[index*4+3] = getIsoValueAtIJK(i  , j+1, k+1, resolution);
            }
        }
    }
}

float getVertIsovalue(float x, float y, float z){
    float val = isoFunction(x,y,z);
    //val = pointsCloudIsovalue(x,y,z);    
    return val;

}
float getVertIsovalue(int index){
    PVector pos = getPositionAtIndex(index);
    float val = isoFunction(pos.x, pos.y, pos.z);
    return val;
}

void setColorAtIndex(int index, float x, float y, float z){
    index*=4;
    colorsVBO.data[index  ] = x*y;
    colorsVBO.data[index+1] = y*z;
    colorsVBO.data[index+2] = z;
    colorsVBO.data[index+3] = 1.0f;
}

void setPositionAtIndex(int index, float x, float y, float z){
    index*=4;
    positionsVBO.data[index  ] = x;
    positionsVBO.data[index+1] = y;
    positionsVBO.data[index+2] = z;
    positionsVBO.data[index+3] = 1.0f;
}

PVector getPositionAtIndex(int index){
    index*=4;
    return new PVector( positionsVBO.data[index  ],
                        positionsVBO.data[index+1],
                        positionsVBO.data[index+2]);
}

float getIsoValueAtIJK(int i, int j, int k, int resolution){    
    return isoValuesArray[i + (j*resolution) + (k*resolution*resolution)];
}

float isoFunction(float x, float y, float z){
        return pow(x, 2) + pow(y, 2) - pow(z, 2) - 50;
}

float pointsCloudIsovalue(float x, float y, float z){

    float isoValue = 0;
    float weight = 1.0f;
    for(int i = 0; i < pCloud.length; i++){
        float dist = max(1.0f, pCloud[i].dist(new PVector(x,y,z)));
        isoValue += (1.0f /  pow(dist,2))*weight;
    }
    return isoValue;
}


