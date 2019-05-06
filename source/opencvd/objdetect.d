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

module opencvd.objdetect;

import std.string;

import opencvd.cvcore;

private extern (C){
    CascadeClassifier CascadeClassifier_New();
    void CascadeClassifier_Close(CascadeClassifier cs);
    int CascadeClassifier_Load(CascadeClassifier cs, const char* name);
    Rects CascadeClassifier_DetectMultiScale(CascadeClassifier cs, Mat img);
    Rects CascadeClassifier_DetectMultiScaleWithParams(CascadeClassifier cs, Mat img,
            double scale, int minNeighbors, int flags, Size minSize, Size maxSize);

    HOGDescriptor HOGDescriptor_New();
    void HOGDescriptor_Close(HOGDescriptor hog);
    int HOGDescriptor_Load(HOGDescriptor hog, const char* name);
    Rects HOGDescriptor_DetectMultiScale(HOGDescriptor hog, Mat img);
    Rects HOGDescriptor_DetectMultiScaleWithParams(HOGDescriptor hog, Mat img,
            double hitThresh, Size winStride, Size padding, double scale, double finalThreshold,
            bool useMeanshiftGrouping);
    Mat HOG_GetDefaultPeopleDetector();
    void HOGDescriptor_SetSVMDetector(HOGDescriptor hog, Mat det);
    Size HOGDescriptor_GetWinSize(HOGDescriptor hd);
    void HOGDescriptor_SetWinSize(HOGDescriptor hd, Size newSize);
    
    
    
    Rects GroupRectangles(Rects rects, int groupThreshold, double eps);
}

struct _CascadeClassifier {
    void* p;
    
    void close(){
        CascadeClassifier_Close(&this);
    }
    
    int load(string name){
        return CascadeClassifier_Load(&this, toStringz(name));
    }
    
    Rects detectMultiScale(Mat img){
        return CascadeClassifier_DetectMultiScale(&this, img);
    }
    
    Rects detectMultiScaleWithParams(Mat img, double scale, int minNeighbors,
                                    int flags, Size minSize, Size maxSize){
        return CascadeClassifier_DetectMultiScaleWithParams(&this, img, scale, 
            minNeighbors, flags, minSize, maxSize);
    }
}

alias CascadeClassifier = _CascadeClassifier*;

CascadeClassifier newCascadeClassifier(){
    return CascadeClassifier_New();
}

struct HOGDescriptor {
    void* p;
    
    static HOGDescriptor opCall(){
        return HOGDescriptor_New();
    }
    
    int load(string name){
        return HOGDescriptor_Load(this, toStringz(name));
    }
    
    Rects detectMultiScale(Mat img){
        return HOGDescriptor_DetectMultiScale(this, img);
    }
    
    Rects detectMultiScaleWithParams(Mat img, double hitThresh, Size winStride,
                Size padding, double scale, double finalThreshold, bool useMeanshiftGrouping){
        return HOGDescriptor_DetectMultiScaleWithParams(this, img, hitThresh, 
                            winStride, padding, scale, finalThreshold, useMeanshiftGrouping);
    }
    
    void setSVMDetector(Mat det){
        HOGDescriptor_SetSVMDetector(this, det);
    }
    
    Size winSize() @property {
        return HOGDescriptor_GetWinSize(this);
    }

    void winSize(Size newSize) @property {
        HOGDescriptor_SetWinSize(this, newSize);
    }
}

void Destroy(HOGDescriptor hd){
    HOGDescriptor_Close(hd);
}

HOGDescriptor newHOGDescriptor(){
    return HOGDescriptor_New();
}

Mat getDefaultPeopleDetectorHOG(){
    return HOG_GetDefaultPeopleDetector();
}

Rects groupRectangles(Rects rects, int groupThreshold, double eps){
    return GroupRectangles(rects, groupThreshold, eps);
}
