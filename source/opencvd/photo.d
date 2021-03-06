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

module opencvd.photo;

import opencvd.cvcore;

private extern (C){
    void DetailEnhance(Mat src, Mat dst, float sigma_s, float sigma_r);
    void EdgePreservingFilter(Mat src, Mat dst, int flags, float sigma_s, float sigma_r);
    void PencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s, float sigma_r, float shade_factor);
    void Stylization (Mat src, Mat dst, float sigma_s, float sigma_r);
    
    void ColorChange(Mat src, Mat mask, Mat dst, float red_mul, float green_mul, float blue_mul);
    void IlluminationChange(Mat src, Mat mask, Mat dst, float alpha, float beta);
    void SeamlessClone(Mat src, Mat dst, Mat mask, Point p, Mat blend, int flags);
    void TextureFlattening(Mat src, Mat mask, Mat dst, float low_threshold, float high_threshold, int kernel_size);
    
    void FastNlMeansDenoising2 (Mat src, Mat dst, float h, int templateWindowSize, int searchWindowSize);
}

enum: int { 
    RECURS_FILTER = 1, 
    NORMCONV_FILTER = 2 
}

void detailEnhance(Mat src, Mat dst, float sigma_s=10, float sigma_r=0.15f){
    DetailEnhance(src, dst, sigma_s, sigma_r);
}

void edgePreservingFilter(Mat src, Mat dst, int flags=1, float sigma_s=60, float sigma_r=0.4f){
    EdgePreservingFilter(src, dst, flags, sigma_s, sigma_r);
}

void pencilSketch(Mat src, Mat dst1, Mat dst2, float sigma_s=60, float sigma_r=0.07f, float shade_factor=0.02f){
    PencilSketch(src, dst1, dst2, sigma_s, sigma_r, shade_factor);
}
void stylization (Mat src, Mat dst, float sigma_s=60, float sigma_r=0.45f){
    Stylization (src, dst, sigma_s, sigma_r);
}

enum: int { 
    NORMAL_CLONE = 1, 
    MIXED_CLONE = 2, 
    MONOCHROME_TRANSFER = 3 
}

void colorChange(Mat src, Mat mask, Mat dst, float red_mul=1.0f, float green_mul=1.0f, float blue_mul=1.0f){
    ColorChange(src, mask, dst, red_mul, green_mul, blue_mul);
}

void illuminationChange(Mat src, Mat mask, Mat dst, float alpha=0.2f, float beta=0.4f){
    IlluminationChange(src, mask, dst, alpha, beta);
}

void seamlessClone(Mat src, Mat dst, Mat mask, Point p, Mat blend, int flags){
    SeamlessClone(src, dst, mask, p, blend, flags);
}

void textureFlattening(Mat src, Mat mask, Mat dst, float low_threshold=30, float high_threshold=45, int kernel_size=3){
    TextureFlattening(src, mask, dst, low_threshold, high_threshold, kernel_size);
}

void fastNlMeansDenoising (Mat src, Mat dst, float h =3, int templateWindowSize = 7,  int searchWindowSize = 21){
    FastNlMeansDenoising2 (src, dst, h, templateWindowSize, searchWindowSize);
}
