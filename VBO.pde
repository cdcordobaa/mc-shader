class VBO{

    FloatBuffer glDataBuffer;
    int glDataLoc;    
    int glVBOId;
    String glAttribName;

    VBO(GL3 gl, float[] data) {

        glDataBuffer = allocateDirectFloatBuffer(data.length);
        IntBuffer intBuffer = IntBuffer.allocate(1);      
        pgl.genBuffers(1, intBuffer);
        glVBOId = intBuffer.get(0);
        println("VBO ID: "  + glVBOId);        

    }

    void setDataLoc(GL3 gl, int glProgram, String glAttribName){
        glDataLoc = gl.glGetAttribLocation(glProgram, glAttribName);
    }

    void bindToShader(GL3 gl, int dataLength, int stride){
        gl.glEnableVertexAttribArray(glDataLoc);        
        gl.glBindBuffer(GL.GL_ARRAY_BUFFER, glVBOId);  
        gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * dataLength, glDataBuffer, GL.GL_DYNAMIC_DRAW);
        gl.glVertexAttribPointer(glDataLoc, stride, GL.GL_FLOAT, false, stride * Float.BYTES, 0);
    }


    FloatBuffer allocateDirectFloatBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
    }

    IntBuffer allocateDirectIntBuffer(int n) {
    return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
    }


}