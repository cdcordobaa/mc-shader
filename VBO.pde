class VBO{

    float data[];
    FloatBuffer glDataBuffer;
    int glDataLoc;    
    int glVBOId;
    String glAttribName;    

    VBO(GL3 gl, float[] data) {
        allocateBuffer(gl, data);
    }

    VBO(GL3 gl, float[] data, int glProgram, String glAttribName) {
        this.glAttribName = glAttribName;
        allocateBuffer(gl, data);
        setDataLoc(gl, glProgram, glAttribName);
        printInfo();
    }

    VBO(GL3 gl, int size, int glProgram, String glAttribName){
        data = new float[size];
        this.glAttribName = glAttribName;
        allocateBuffer(gl, data);
        setDataLoc(gl, glProgram, glAttribName);
        printInfo();
    }

    void allocateBuffer(GL3 gl, float[] data){
        glDataBuffer = allocateDirectFloatBuffer(data.length);
        IntBuffer intBuffer = IntBuffer.allocate(1);      
        gl.glGenBuffers(1, intBuffer);
        glVBOId = intBuffer.get(0);        
    }

    void setDataLoc(GL3 gl, int glProgram, String glAttribName){
        glDataLoc = gl.glGetAttribLocation(glProgram, glAttribName);
    }

    void enableVertAttrib(GL3 gl, int dataLength, int stride){
        gl.glEnableVertexAttribArray(glDataLoc);        
        gl.glBindBuffer(GL.GL_ARRAY_BUFFER, glVBOId);  
        gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * dataLength, glDataBuffer, GL.GL_DYNAMIC_DRAW);
        gl.glVertexAttribPointer(glDataLoc, stride, GL.GL_FLOAT, false, stride * Float.BYTES, 0);       
        gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);        
    }

    void enableVertAttrib(GL3 gl, int stride){
        enableVertAttrib(gl, data.length, stride);
    }

    void disableVertAttrib(GL3 gl){
        gl.glDisableVertexAttribArray(glDataLoc);
    }

    void updateBuffer(float[] data){
        glDataBuffer.rewind();
        glDataBuffer.put(data);
        glDataBuffer.rewind();
    }

    void updateBuffer(){
        glDataBuffer.rewind();
        glDataBuffer.put(data);
        glDataBuffer.rewind();
    }

    void printInfo(){
        println("VBO(id: "+glVBOId+", name: "+glAttribName+", alloc: "+glDataLoc+")");        
        //println("VBO size: "  + data.length);
        //println("VBO DATA[]: ");
    }
    FloatBuffer allocateDirectFloatBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
    }

    IntBuffer allocateDirectIntBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
    }

}