/*
Copyright (c) 2019 Ferhat Kurtulmuş
Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:
The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module opencvd.dnn;

import core.stdc.stdint;
import std.conv;
import std.string;

import opencvd.cvcore;

private extern (C) {
    Net Net_ReadNet(const char* model, const char* config);
    Net Net_ReadNetBytes(const char* framework, ByteArray model, ByteArray config);
    Net Net_ReadNetFromCaffe(const char* prototxt, const char* caffeModel);
    Net Net_ReadNetFromCaffeBytes(ByteArray prototxt, ByteArray caffeModel);
    Net Net_ReadNetFromTensorflow(const char* model);
    Net Net_ReadNetFromTensorflowBytes(ByteArray model);
    Mat Net_BlobFromImage(Mat image, double scalefactor, Size size, Scalar mean, bool swapRB,
                          bool crop);
    void Net_Close(Net net);
    bool Net_Empty(Net net);
    void Net_SetInput(Net net, Mat blob, const char* name);
    Mat Net_Forward(Net net, const char* outputName);
    void Net_ForwardLayers(Net net, Mats* outputBlobs, CStrings outBlobNames);
    void Net_SetPreferableBackend(Net net, int backend);
    void Net_SetPreferableTarget(Net net, int target);
    int64_t Net_GetPerfProfile(Net net);
    void Net_GetUnconnectedOutLayers(Net net, IntVector* res);

    Mat Net_GetBlobChannel(Mat blob, int imgidx, int chnidx);
    Scalar Net_GetBlobSize(Mat blob);

    Layer Net_GetLayer(Net net, int layerid);
    void Layer_Close(Layer layer);
    int Layer_InputNameToIndex(Layer layer, const char* name);
    int Layer_OutputNameToIndex(Layer layer, const char* name);
    const(char*) Layer_GetName(Layer layer);
    const(char*) Layer_GetType(Layer layer);
}

enum: int { 
    DNN_BACKEND_DEFAULT, 
    DNN_BACKEND_HALIDE, 
    DNN_BACKEND_INFERENCE_ENGINE, 
    DNN_BACKEND_OPENCV, 
    DNN_BACKEND_VKCOM,
}

enum: int {
    DNN_TARGET_CPU,
    DNN_TARGET_OPENCL,
    DNN_TARGET_OPENCL_FP16,
    DNN_TARGET_MYRIAD,
    DNN_TARGET_VULKAN,
    DNN_TARGET_FPGA
}

struct Net {
    void* p;
    
    bool empty(){
        return Net_Empty(this) == 0 ? false: true;
    }
    
    void setInput(Mat blob, string name = ""){
        Net_SetInput(this, blob, name.toStringz);
    }
    
    Mat forward(string outputName = ""){
        Mat _net = Net_Forward(this, outputName.toStringz);
        return _net;
    }
    
    void forward(ref Mat[] outputBlobs, string[] outBlobNames){
        CStrings coutBlobNames = {cast(const(char**))outBlobNames.ptr, outBlobNames.length.to!int};
        Mats* obs;
        Net_ForwardLayers(this, obs, coutBlobNames);
        
        outputBlobs = obs.mats[0..obs.length].dup;
        deleteArr(obs.mats);
    }
    
    void setPreferableBackend(int backend){
        Net_SetPreferableBackend(this, backend);
    }
    
    void setPreferableTarget(int target){
        Net_SetPreferableTarget(this, target);
    }
    
    int64_t getPerfProfile(){
        return Net_GetPerfProfile(this);
    }
    
    void getUnconnectedOutLayers(ref int[] res){
        IntVector* _res;
        Net_GetUnconnectedOutLayers(this, _res);
        
        res = _res.val[0.._res.length].dup;
        deleteArr(_res.val);
    }

    Layer getLayer(int layerid){
        return Net_GetLayer(this, layerid);
    }
}

Mat getBlobChannel(Mat blob, int imgidx, int chnidx){
    return Net_GetBlobChannel(blob, imgidx, chnidx);
}

Scalar getBlobSize(Mat blob){
    return Net_GetBlobSize(blob);
}

void Destroy(Net net){
    Net_Close(net);
}

Net readNet(string model, string config){
    return Net_ReadNet(toStringz(model), toStringz(config));
}
    
Net readNetBytes(string framework, ubyte[] model, ubyte[] config){
    return Net_ReadNetBytes(framework.toStringz, ByteArray(model.ptr, model.length.to!int), ByteArray(config.ptr, config.length.to!int));
}

Net readNetFromCaffe(string prototxt, string caffeModel){
    return Net_ReadNetFromCaffe(prototxt.toStringz, caffeModel.toStringz);
}

Net readNetFromCaffeBytes(ubyte[] prototxt, ubyte[] caffeModel){
    return Net_ReadNetFromCaffeBytes(ByteArray(prototxt.ptr, prototxt.length.to!int),
        ByteArray(caffeModel.ptr, caffeModel.length.to!int));
}

Net readNetFromTensorflow(string model){
    return Net_ReadNetFromTensorflow(model.toStringz);
}

Net readNetFromTensorflowBytes(ubyte[] model){
    return Net_ReadNetFromTensorflowBytes(ByteArray(model.ptr, model.length.to!int));
}

Mat blobFromImage(Mat image, double scalefactor=1.0, Size size = Size(), Scalar mean = Scalar(), bool swapRB = false, bool crop = false){
    return Net_BlobFromImage(image, scalefactor, size, mean, swapRB, crop);
}

struct Layer {
    void* p;
        
    int inputNameToIndex(string name){
        return Layer_InputNameToIndex(this, name.toStringz);
    }
    
    int outputNameToIndex(string name){
        return Layer_OutputNameToIndex(this, name.toStringz);
    }
    
    string getName(){
        return Layer_GetName(this).to!string;
    }
    
    string getType(){
        return Layer_GetType(this).to!string;
    }
    
}

void Destroy(Layer layer){
    Layer_Close(layer);
}