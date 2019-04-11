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

module opencvd.imgproc;

import std.stdio;
import std.string;
import std.typecons;
import core.stdc.stdlib;

import opencvd.cvcore;

private {
    extern (C){
        double ArcLength(Contour curve, bool is_closed);
        Contour ApproxPolyDP(Contour curve, double epsilon, bool closed);
        void CvtColor(Mat src, Mat dst, int code);
        void EqualizeHist(Mat src, Mat dst);
        void CalcHist(Mats mats, IntVector chans, Mat mask, Mat hist, IntVector sz, FloatVector rng, bool acc);
        void ConvexHull(Contour points, Mat hull, bool clockwise, bool returnPoints);
        void ConvexityDefects(Contour points, Mat hull, Mat result);
        void BilateralFilter(Mat src, Mat dst, int d, double sc, double ss);
        void Blur(Mat src, Mat dst, Size ps);
        void BoxFilter(Mat src, Mat dst, int ddepth, Size ps);
        void SqBoxFilter(Mat src, Mat dst, int ddepth, Size ps);
        void Dilate(Mat src, Mat dst, Mat kernel);
        void Erode(Mat src, Mat dst, Mat kernel);
        void MatchTemplate(Mat image, Mat templ, Mat result, int method, Mat mask);
        Moment Moments(Mat src, bool binaryImage);
        void PyrDown(Mat src, Mat dst, Size dstsize, int borderType);
        void PyrUp(Mat src, Mat dst, Size dstsize, int borderType);
        Rect BoundingRect(Contour con);
        void BoxPoints(RotatedRect rect, Mat boxPts);
        double ContourArea(Contour con);
        RotatedRect MinAreaRect(Points points);
        void MinEnclosingCircle(Points points, Point2f* center, float* radius);
        Contours FindContours(Mat src, int mode, int method);
        Contours FindContoursWithHier(Mat src, Hierarchy **chierarchy, int mode, int method);
        int ConnectedComponents(Mat src, Mat dst, int connectivity, int ltype, int ccltype);
        int ConnectedComponentsWithStats(Mat src, Mat labels, Mat stats, Mat centroids, int connectivity, int ltype, int ccltype);

        void GaussianBlur(Mat src, Mat dst, Size ps, double sX, double sY, int bt);
        void Laplacian(Mat src, Mat dst, int dDepth, int kSize, double scale, double delta, int borderType);
        void Scharr(Mat src, Mat dst, int dDepth, int dx, int dy, double scale, double delta,
                    int borderType);
        Mat GetStructuringElement(int shape, Size ksize);
        Mat GetStructuringElementWithAnchor(int shape, Size ksize, Point anchor);
        void MorphologyEx(Mat src, Mat dst, int op, Mat kernel);
        void MedianBlur(Mat src, Mat dst, int ksize);
        
        void Canny(Mat src, Mat edges, double t1, double t2);
        void Canny2(Mat dx, Mat dy, Mat edges, double threshold1, double threshold2, bool L2gradient);
        void CornerSubPix(Mat img, Mat corners, Size winSize, Size zeroZone, TermCriteria criteria);
        void GoodFeaturesToTrack(Mat img, Mat corners, int maxCorners, double quality, double minDist);
        void HoughCircles(Mat src, Mat circles, int method, double dp, double minDist);
        void HoughCirclesWithParams(Mat src, Mat circles, int method, double dp, double minDist,
                                    double param1, double param2, int minRadius, int maxRadius);
        void HoughLines(Mat src, Mat lines, double rho, double theta, int threshold);
        void HoughLinesP(Mat src, Mat lines, double rho, double theta, int threshold);
        void HoughLinesPWithParams(Mat src, Mat lines, double rho, double theta, int threshold, double minLineLength, double maxLineGap);
        void HoughLinesPointSet(Mat points, Mat lines, int lines_max, int threshold,
                                double min_rho, double  max_rho, double rho_step,
                                double min_theta, double max_theta, double theta_step);
        void Threshold(Mat src, Mat dst, double thresh, double maxvalue, int typ);
        void AdaptiveThreshold(Mat src, Mat dst, double maxValue, int adaptiveTyp, int typ, int blockSize,
                               double c);
                               
        void ArrowedLine(Mat img, Point pt1, Point pt2, Scalar color, int thickness);
        void Circle(Mat img, Point center, int radius, Scalar color, int thickness);
        void Ellipse(Mat img, Point center, Point axes, double angle, double
                     startAngle, double endAngle, Scalar color, int thickness);
        void Line(Mat img, Point pt1, Point pt2, Scalar color, int thickness);
        void Rectangle(Mat img, Rect rect, Scalar color, int thickness);
        void FillPoly(Mat img, Contours points, Scalar color);
        Size GetTextSize(const char* text, int fontFace, double fontScale, int thickness);
        void PutText(Mat img, const char* text, Point org, int fontFace, double fontScale,
                     Scalar color, int thickness);
        void Resize(Mat src, Mat dst, Size sz, double fx, double fy, int interp);
        Mat GetRotationMatrix2D(Point center, double angle, double scale);
        void WarpAffine(Mat src, Mat dst, Mat rot_mat, Size dsize);
        void WarpAffineWithParams(Mat src, Mat dst, Mat rot_mat, Size dsize, int flags, int borderMode,
                                  Scalar borderValue);
        void WarpPerspective(Mat src, Mat dst, Mat m, Size dsize);
        void ApplyColorMap(Mat src, Mat dst, int colormap);
        void ApplyCustomColorMap(Mat src, Mat dst, Mat colormap);
        Mat GetPerspectiveTransform(Contour src, Contour dst);
        void DrawContours(Mat src, Contours contours, int contourIdx, Scalar color, int thickness);
        void DrawContours2(
            Mat image,
            Contours contours,
            int contourIdx,
            Scalar color,
            int thickness,
            int lineType,
            Hierarchy hierarchy,
            int maxLevel,
            Point offset
        );
        void Sobel(Mat src, Mat dst, int ddepth, int dx, int dy, int ksize, double scale, double delta, int borderType);
        void SpatialGradient(Mat src, Mat dx, Mat dy, int ksize, int borderType);
        void Remap(Mat src, Mat dst, Mat map1, Mat map2, int interpolation, int borderMode, Scalar borderValue);
        void Filter2D(Mat src, Mat dst, int ddepth, Mat kernel, Point anchor, double delta, int borderType);
        void SepFilter2D(Mat src, Mat dst, int ddepth, Mat kernelX, Mat kernelY, Point anchor, double delta, int borderType);
        void LogPolar(Mat src, Mat dst, Point center, double m, int flags);
        void FitLine(Contour points, Mat line, int distType, double param, double reps, double aeps);
        CLAHE CLAHE_Create();
        CLAHE CLAHE_CreateWithParams(double clipLimit, Size tileGridSize);
        void CLAHE_Close(CLAHE c);
        void CLAHE_Apply(CLAHE c, Mat src, Mat dst);
        
        void Watershed(Mat src, Mat markers);
        int FloodFill(Mat image, Mat mask, Point seedPoint, Scalar  newVal,
                Rect rect, Scalar loDiff, Scalar upDiff, int flags);
    }
}
double arcLength(Contour curve, bool is_closed){
    return ArcLength(curve, is_closed);
}

Contour approxPolyDP(Contour curve, double epsilon, bool isClosed){
    return ApproxPolyDP(curve, epsilon, isClosed);
}

void cvtColor(Mat src, Mat dst, int code){
    CvtColor(src, dst, code);
}

void equalizeHist(Mat src, Mat dst){
    EqualizeHist(src, dst);
}

void calcHist(Mats mats, IntVector chans, Mat mask, Mat hist, IntVector sz, FloatVector rng, bool acc){
    CalcHist(mats, chans, mask, hist, sz, rng, acc);
}

void convexHull(Contour points, Mat hull, bool clockwise, bool returnPoints){
    ConvexHull(points, hull, clockwise, returnPoints);
}

void convexityDefects(Contour points, Mat hull, Mat result){
    ConvexityDefects(points, hull, result);
}

void bilateralFilter(Mat src, Mat dst, int d, double sc, double ss){
    BilateralFilter(src, dst, d, sc, ss);
}

void blur(Mat src, Mat dst, Size ps){
    Blur(src, dst, ps);
}

void boxFilter(Mat src, Mat dst, int ddepth, Size ps){
    BoxFilter(src, dst, ddepth, ps);
}

void sqBoxFilter(Mat src, Mat dst, int ddepth, Size ps){
    SqBoxFilter(src, dst, ddepth, ps);
}

void dilate(Mat src, Mat dst, Mat kernel){
    Dilate(src, dst, kernel);
}

void erode(Mat src, Mat dst, Mat kernel){
    Erode(src, dst, kernel);
}

void matchTemplate(Mat image, Mat templ, Mat result, int method, Mat mask){
    MatchTemplate(image, templ, result, method, mask);
}

Moment moments(Mat src, bool isBinaryImage){
    return Moments(src, isBinaryImage);
}

void pyrDown(Mat src, Mat dst, Size dstsize, int borderType){
    PyrDown(src, dst, dstsize, borderType);
}

void pyrUp(Mat src, Mat dst, Size dstsize, int borderType){
    PyrUp(src, dst, dstsize, borderType);
}

Rect boundingRect(Contour con){
    return BoundingRect(con);
}

void boxPoints(RotatedRect rect, Mat boxPts){
    BoxPoints(rect, boxPts);
}

double contourArea(Contour con){
    return ContourArea(con);
}

RotatedRect minAreaRect(Points points){
    return MinAreaRect(points);
}
void minEnclosingCircle(Points points, Point2f* center, float* radius){
    MinEnclosingCircle(points, center, radius);
}

// enum cv::RetrievalModes for findContours
enum: int {
    RETR_EXTERNAL,
    RETR_LIST,
    RETR_CCOMP,
    RETR_TREE,
    RETR_FLOODFILL
}
// enum cv::ContourApproximationModes for findContours
enum: int {
    CHAIN_APPROX_NONE,
    CHAIN_APPROX_SIMPLE,
    CHAIN_APPROX_TC89_L1,
    CHAIN_APPROX_TC89_KCOS
}

Contours findContours(Mat src, int mode, int method){
    return FindContours(src, mode, method);
}

Tuple!(Contours, Hierarchy) findContoursWithHier(Mat src, int mode, int method){
    Hierarchy *chier;// = null;
    auto cntrs = FindContoursWithHier(src, &chier, mode, method);
    //chier.scalars.writeln;
    Hierarchy rethie = {scalars: chier.scalars, length: chier.length};
    destroy(chier);
    return tuple(cntrs, rethie);
}

int connectedComponents(Mat src, Mat dst, int connectivity, int ltype, int ccltype){
    return ConnectedComponents(src, dst, connectivity, ltype, ccltype);
}

int connectedComponentsWithStats(Mat src, Mat labels, Mat stats, Mat centroids, int connectivity, int ltype, int ccltype){
    return ConnectedComponentsWithStats(src, labels, stats, centroids, connectivity, ltype, ccltype);
}

void gaussianBlur(Mat src, Mat dst, Size ps, double sX, double sY, int bt){
    GaussianBlur(src, dst, ps, sX, sY, bt);
}

void laplacian(Mat src, Mat dst, int dDepth, int kSize, double scale, double delta, int borderType){
    Laplacian(src, dst, dDepth, kSize, scale, delta, borderType);
}

void scharr(Mat src, Mat dst, int dDepth, int dx, int dy, double scale, double delta,
            int borderType){
    Scharr(src, dst, dDepth, dx, dy, scale, delta, borderType);
}

enum: int { // cv::MorphShapes
    MORPH_RECT,
    MORPH_CROSS,
    MORPH_ELLIPSE
}

Mat getStructuringElement(int shape, Size ksize){
    return getStructuringElement(shape, ksize);
}

Mat getStructuringElement(int shape, Size ksize, Point anchor){
    return GetStructuringElementWithAnchor(shape, ksize, anchor);
}

enum: int { // cv::MorphTypes
    MORPH_ERODE,
    MORPH_DILATE,
    MORPH_OPEN,
    MORPH_CLOSE,
    MORPH_GRADIENT,
    MORPH_TOPHAT,
    MORPH_BLACKHAT,
    MORPH_HITMISS
}

void morphologyEx(Mat src, Mat dst, int op, Mat kernel){
    MorphologyEx(src, dst, op, kernel);
}

void medianBlur(Mat src, Mat dst, int ksize){
    MedianBlur(src, dst, ksize);
}

void canny(Mat src, Mat edges, double t1, double t2){
    Canny(src, edges, t1, t2);
}

void canny(Mat dx, Mat dy, Mat edges, double threshold1, double threshold2, bool L2gradient = false){
    Canny2(dx, dy, edges, threshold1, threshold2, L2gradient);
}

void cornerSubPix(Mat img, Mat corners, Size winSize, Size zeroZone, TermCriteria criteria){
    CornerSubPix(img, corners, winSize, zeroZone, criteria);
}

void goodFeaturesToTrack(Mat img, Mat corners, int maxCorners, double quality, double minDist){
    GoodFeaturesToTrack(img, corners, maxCorners, quality, minDist);
}

void houghCircles(Mat src, Mat circles, int method, double dp, double minDist){
    HoughCircles(src, circles, method, dp, minDist);
}
void houghCirclesWithParams(Mat src, Mat circles, int method, double dp, double minDist,
                            double param1, double param2, int minRadius, int maxRadius){
    HoughCirclesWithParams(src, circles, method, dp, minDist,
                            param1, param2, minRadius, maxRadius);
}

void houghLines(Mat src, Mat lines, double rho, double theta, int threshold){
    HoughLines(src, lines, rho, theta, threshold);
}

void houghLinesP(Mat src, Mat lines, double rho, double theta, int threshold){
    HoughLinesP(src, lines, rho, theta, threshold);
}

void houghLinesPWithParams(Mat src, Mat lines, double rho, double theta, int threshold, double minLineLength, double maxLineGap){
    HoughLinesPWithParams(src, lines, rho, theta, threshold, minLineLength, maxLineGap);
}

void houghLinesPointSet(Mat points, Mat lines, int lines_max, int threshold,
                        double min_rho, double  max_rho, double rho_step,
                        double min_theta, double max_theta, double theta_step){
    HoughLinesPointSet(points, lines, lines_max, threshold,
                        min_rho, max_rho, rho_step,
                        min_theta, max_theta, theta_step);
}

enum: int {
    THRESH_BINARY,
    THRESH_BINARY_INV,
    THRESH_TRUNC,
    THRESH_TOZERO,
    THRESH_TOZERO_INV,
    THRESH_MASK,
    THRESH_OTSU,
    THRESH_TRIANGLE
}

void threshold(Mat src, Mat dst, double thresh, double maxvalue, int typ){
    Threshold(src, dst, thresh, maxvalue, typ);
}

void adaptiveThreshold(Mat src, Mat dst, double maxValue, int adaptiveTyp, int typ, int blockSize,
                       double c){
    AdaptiveThreshold(src, dst, maxValue, adaptiveTyp, typ, blockSize, c);
}


void arrowedLine(Mat img, Point pt1, Point pt2, Scalar color, int thickness){
    ArrowedLine(img, pt1, pt2, color, thickness);
}

void circle(Mat img, Point center, int radius, Scalar color, int thickness){
    Circle(img, center, radius, color, thickness);
}

void ellipse(Mat img, Point center, Point axes, double angle, double
             startAngle, double endAngle, Scalar color, int thickness){
    Ellipse(img, center, axes, angle, startAngle, endAngle, color, thickness);
}

void line(Mat img, Point pt1, Point pt2, Scalar color, int thickness){
    Line(img, pt1, pt2, color, thickness);
}

void rectangle(Mat img, Rect rect, Scalar color, int thickness){
    Rectangle(img, rect, color, thickness);
}

void fillPoly(Mat img, Contours points, Scalar color){
    FillPoly(img, points, color);
}

Size getTextSize(string text, int fontFace, double fontScale, int thickness){
    return GetTextSize(toStringz(text), fontFace, fontScale, thickness);
}

void putText(Mat img, string text, Point org, int fontFace, double fontScale,
             Scalar color, int thickness){
    PutText(img, toStringz(text), org, fontFace, fontScale, color, thickness);
}

void resize(Mat src, Mat dst, Size sz, double fx, double fy, int interp){
    Resize(src, dst, sz, fx, fy, interp);
}

Mat getRotationMatrix2D(Point center, double angle, double scale){
    return GetRotationMatrix2D(center, angle, scale);
}

void warpAffine(Mat src, Mat dst, Mat rot_mat, Size dsize){
    WarpAffine(src, dst, rot_mat, dsize);
}

void warpAffineWithParams(Mat src, Mat dst, Mat rot_mat, Size dsize, int flags, int borderMode,
                          Scalar borderValue){
    WarpAffineWithParams(src, dst, rot_mat, dsize, flags, borderMode, borderValue);
}

void warpPerspective(Mat src, Mat dst, Mat m, Size dsize){
    WarpPerspective(src, dst, m, dsize);
}

void applyColorMap(Mat src, Mat dst, int colormap){
    ApplyColorMap(src, dst, colormap);
}

void applyCustomColorMap(Mat src, Mat dst, Mat colormap){
    ApplyCustomColorMap(src, dst, colormap);
}

Mat getPerspectiveTransform(Contour src, Contour dst){
    return GetPerspectiveTransform(src, dst);
}

void drawContours(Mat src, Contours contours, int contourIdx, Scalar color, int thickness){
    DrawContours(src, contours, contourIdx, color, thickness);
}

void drawContours(
            Mat image,
            Contours contours,
            int contourIdx,
            Scalar color,
            int thickness,
            int lineType,
            Hierarchy hierarchy,
            int maxLevel,
            Point offset = Point(0,0)
        ){
    DrawContours2(image, contours, contourIdx, color, thickness, lineType, hierarchy, maxLevel, offset);
}

void sobel(Mat src, Mat dst, int ddepth, int dx, int dy, int ksize, double scale, double delta, int borderType){
    Sobel(src, dst, ddepth, dx, dy, ksize, scale, delta, borderType);
}

void spatialGradient(Mat src, Mat dx, Mat dy, int ksize, int borderType){
    SpatialGradient(src, dx, dy, ksize, borderType);
}

void remap(Mat src, Mat dst, Mat map1, Mat map2, int interpolation, int borderMode, Scalar borderValue){
    Remap(src, dst, map1, map2, interpolation, borderMode, borderValue);
}

void filter2D(Mat src, Mat dst, int ddepth, Mat kernel, Point anchor, double delta, int borderType){
    Filter2D(src, dst, ddepth, kernel, anchor, delta, borderType);
}

void sepFilter2D(Mat src, Mat dst, int ddepth, Mat kernelX, Mat kernelY, Point anchor, double delta, int borderType){
    SepFilter2D(src, dst, ddepth, kernelX, kernelY, anchor, delta, borderType);
}

void logPolar(Mat src, Mat dst, Point center, double m, int flags){
    LogPolar(src, dst, center, m, flags);
}

void fitLine(Contour points, Mat line, int distType, double param, double reps, double aeps){
    FitLine(points, line, distType, param, reps, aeps);
}

void watershed(Mat src, Mat markers){
    Watershed(src, markers);
}

int floodFill(Mat image, Mat mask, Point seedPoint, Scalar  newVal,
                Rect rect, Scalar loDiff, Scalar upDiff, int flags){
    return FloodFill(image, mask, seedPoint, newVal, rect, loDiff, upDiff, flags);
}

// Contrast-limited adaptive histogram equalization
struct _CLAHE{
	void* p;
    
    void close(){
        CLAHE_Close(&this);
    }
    
    void apply(Mat src, Mat dst){
        CLAHE_Apply(&this, src, dst);
    }
}

alias CLAHE = _CLAHE*;

CLAHE newCLAHE(){ // implement in 'this'?
    return CLAHE_Create();
}

CLAHE newCLAHEWithParams(double clipLimit, Size tileGridSize){ // implement in 'this'?
    return CLAHE_CreateWithParams(clipLimit, tileGridSize);
}

enum: int {
    COLOR_BGR2BGRA = 0, 

    COLOR_RGB2RGBA = COLOR_BGR2BGRA, 

    COLOR_BGRA2BGR = 1, 

    COLOR_RGBA2RGB = COLOR_BGRA2BGR, 

    COLOR_BGR2RGBA = 2, 

    COLOR_RGB2BGRA = COLOR_BGR2RGBA, 

    COLOR_RGBA2BGR = 3, 

    COLOR_BGRA2RGB = COLOR_RGBA2BGR, 

    COLOR_BGR2RGB = 4, 

    COLOR_RGB2BGR = COLOR_BGR2RGB, 

    COLOR_BGRA2RGBA = 5, 

    COLOR_RGBA2BGRA = COLOR_BGRA2RGBA, 

    COLOR_BGR2GRAY = 6, 

    COLOR_RGB2GRAY = 7, 

    COLOR_GRAY2BGR = 8, 

    COLOR_GRAY2RGB = COLOR_GRAY2BGR, 

    COLOR_GRAY2BGRA = 9, 

    COLOR_GRAY2RGBA = COLOR_GRAY2BGRA, 

    COLOR_BGRA2GRAY = 10, 

    COLOR_RGBA2GRAY = 11, 

    COLOR_BGR2BGR565 = 12, 

    COLOR_RGB2BGR565 = 13, 

    COLOR_BGR5652BGR = 14, 

    COLOR_BGR5652RGB = 15, 

    COLOR_BGRA2BGR565 = 16, 

    COLOR_RGBA2BGR565 = 17, 

    COLOR_BGR5652BGRA = 18, 

    COLOR_BGR5652RGBA = 19, 

    COLOR_GRAY2BGR565 = 20, 

    COLOR_BGR5652GRAY = 21, 

    COLOR_BGR2BGR555 = 22, 

    COLOR_RGB2BGR555 = 23, 

    COLOR_BGR5552BGR = 24, 

    COLOR_BGR5552RGB = 25, 

    COLOR_BGRA2BGR555 = 26, 

    COLOR_RGBA2BGR555 = 27, 

    COLOR_BGR5552BGRA = 28, 

    COLOR_BGR5552RGBA = 29, 

    COLOR_GRAY2BGR555 = 30, 

    COLOR_BGR5552GRAY = 31, 

    COLOR_BGR2XYZ = 32, 

    COLOR_RGB2XYZ = 33, 

    COLOR_XYZ2BGR = 34, 

    COLOR_XYZ2RGB = 35, 

    COLOR_BGR2YCrCb = 36, 

    COLOR_RGB2YCrCb = 37, 

    COLOR_YCrCb2BGR = 38, 

    COLOR_YCrCb2RGB = 39, 

    COLOR_BGR2HSV = 40, 

    COLOR_RGB2HSV = 41, 

    COLOR_BGR2Lab = 44, 

    COLOR_RGB2Lab = 45, 

    COLOR_BGR2Luv = 50, 

    COLOR_RGB2Luv = 51, 

    COLOR_BGR2HLS = 52, 

    COLOR_RGB2HLS = 53, 

    COLOR_HSV2BGR = 54, 

    COLOR_HSV2RGB = 55, 

    COLOR_Lab2BGR = 56, 

    COLOR_Lab2RGB = 57, 

    COLOR_Luv2BGR = 58, 

    COLOR_Luv2RGB = 59, 

    COLOR_HLS2BGR = 60, 

    COLOR_HLS2RGB = 61, 

    COLOR_BGR2HSV_FULL = 66, 

    COLOR_RGB2HSV_FULL = 67, 

    COLOR_BGR2HLS_FULL = 68, 

    COLOR_RGB2HLS_FULL = 69, 

    COLOR_HSV2BGR_FULL = 70, 

    COLOR_HSV2RGB_FULL = 71, 

    COLOR_HLS2BGR_FULL = 72, 

    COLOR_HLS2RGB_FULL = 73, 

    COLOR_LBGR2Lab = 74, 

    COLOR_LRGB2Lab = 75, 

    COLOR_LBGR2Luv = 76, 

    COLOR_LRGB2Luv = 77, 

    COLOR_Lab2LBGR = 78, 

    COLOR_Lab2LRGB = 79, 

    COLOR_Luv2LBGR = 80, 

    COLOR_Luv2LRGB = 81, 

    COLOR_BGR2YUV = 82, 

    COLOR_RGB2YUV = 83, 

    COLOR_YUV2BGR = 84, 

    COLOR_YUV2RGB = 85, 

    COLOR_YUV2RGB_NV12 = 90, 

    COLOR_YUV2BGR_NV12 = 91, 

    COLOR_YUV2RGB_NV21 = 92, 

    COLOR_YUV2BGR_NV21 = 93, 

    COLOR_YUV420sp2RGB = COLOR_YUV2RGB_NV21, 

    COLOR_YUV420sp2BGR = COLOR_YUV2BGR_NV21, 

    COLOR_YUV2RGBA_NV12 = 94, 

    COLOR_YUV2BGRA_NV12 = 95, 

    COLOR_YUV2RGBA_NV21 = 96, 

    COLOR_YUV2BGRA_NV21 = 97, 

    COLOR_YUV420sp2RGBA = COLOR_YUV2RGBA_NV21, 

    COLOR_YUV420sp2BGRA = COLOR_YUV2BGRA_NV21, 

    COLOR_YUV2RGB_YV12 = 98, 

    COLOR_YUV2BGR_YV12 = 99, 

    COLOR_YUV2RGB_IYUV = 100, 

    COLOR_YUV2BGR_IYUV = 101, 

    COLOR_YUV2RGB_I420 = COLOR_YUV2RGB_IYUV, 

    COLOR_YUV2BGR_I420 = COLOR_YUV2BGR_IYUV, 

    COLOR_YUV420p2RGB = COLOR_YUV2RGB_YV12, 

    COLOR_YUV420p2BGR = COLOR_YUV2BGR_YV12, 

    COLOR_YUV2RGBA_YV12 = 102, 

    COLOR_YUV2BGRA_YV12 = 103, 

    COLOR_YUV2RGBA_IYUV = 104, 

    COLOR_YUV2BGRA_IYUV = 105, 

    COLOR_YUV2RGBA_I420 = COLOR_YUV2RGBA_IYUV, 

    COLOR_YUV2BGRA_I420 = COLOR_YUV2BGRA_IYUV, 

    COLOR_YUV420p2RGBA = COLOR_YUV2RGBA_YV12, 

    COLOR_YUV420p2BGRA = COLOR_YUV2BGRA_YV12, 

    COLOR_YUV2GRAY_420 = 106, 

    COLOR_YUV2GRAY_NV21 = COLOR_YUV2GRAY_420, 

    COLOR_YUV2GRAY_NV12 = COLOR_YUV2GRAY_420, 

    COLOR_YUV2GRAY_YV12 = COLOR_YUV2GRAY_420, 

    COLOR_YUV2GRAY_IYUV = COLOR_YUV2GRAY_420, 

    COLOR_YUV2GRAY_I420 = COLOR_YUV2GRAY_420, 

    COLOR_YUV420sp2GRAY = COLOR_YUV2GRAY_420, 

    COLOR_YUV420p2GRAY = COLOR_YUV2GRAY_420, 

    COLOR_YUV2RGB_UYVY = 107, 

    COLOR_YUV2BGR_UYVY = 108, 

    COLOR_YUV2RGB_Y422 = COLOR_YUV2RGB_UYVY, 

    COLOR_YUV2BGR_Y422 = COLOR_YUV2BGR_UYVY, 

    COLOR_YUV2RGB_UYNV = COLOR_YUV2RGB_UYVY, 

    COLOR_YUV2BGR_UYNV = COLOR_YUV2BGR_UYVY, 

    COLOR_YUV2RGBA_UYVY = 111, 

    COLOR_YUV2BGRA_UYVY = 112, 

    COLOR_YUV2RGBA_Y422 = COLOR_YUV2RGBA_UYVY, 

    COLOR_YUV2BGRA_Y422 = COLOR_YUV2BGRA_UYVY, 

    COLOR_YUV2RGBA_UYNV = COLOR_YUV2RGBA_UYVY, 

    COLOR_YUV2BGRA_UYNV = COLOR_YUV2BGRA_UYVY, 

    COLOR_YUV2RGB_YUY2 = 115, 

    COLOR_YUV2BGR_YUY2 = 116, 

    COLOR_YUV2RGB_YVYU = 117, 

    COLOR_YUV2BGR_YVYU = 118, 

    COLOR_YUV2RGB_YUYV = COLOR_YUV2RGB_YUY2, 

    COLOR_YUV2BGR_YUYV = COLOR_YUV2BGR_YUY2, 

    COLOR_YUV2RGB_YUNV = COLOR_YUV2RGB_YUY2, 

    COLOR_YUV2BGR_YUNV = COLOR_YUV2BGR_YUY2, 

    COLOR_YUV2RGBA_YUY2 = 119, 

    COLOR_YUV2BGRA_YUY2 = 120, 

    COLOR_YUV2RGBA_YVYU = 121, 

    COLOR_YUV2BGRA_YVYU = 122, 

    COLOR_YUV2RGBA_YUYV = COLOR_YUV2RGBA_YUY2, 

    COLOR_YUV2BGRA_YUYV = COLOR_YUV2BGRA_YUY2, 

    COLOR_YUV2RGBA_YUNV = COLOR_YUV2RGBA_YUY2, 

    COLOR_YUV2BGRA_YUNV = COLOR_YUV2BGRA_YUY2, 

    COLOR_YUV2GRAY_UYVY = 123, 

    COLOR_YUV2GRAY_YUY2 = 124, 

    COLOR_YUV2GRAY_Y422 = COLOR_YUV2GRAY_UYVY, 

    COLOR_YUV2GRAY_UYNV = COLOR_YUV2GRAY_UYVY, 

    COLOR_YUV2GRAY_YVYU = COLOR_YUV2GRAY_YUY2, 

    COLOR_YUV2GRAY_YUYV = COLOR_YUV2GRAY_YUY2, 

    COLOR_YUV2GRAY_YUNV = COLOR_YUV2GRAY_YUY2, 

    COLOR_RGBA2mRGBA = 125, 

    COLOR_mRGBA2RGBA = 126, 

    COLOR_RGB2YUV_I420 = 127, 

    COLOR_BGR2YUV_I420 = 128, 

    COLOR_RGB2YUV_IYUV = COLOR_RGB2YUV_I420, 

    COLOR_BGR2YUV_IYUV = COLOR_BGR2YUV_I420, 

    COLOR_RGBA2YUV_I420 = 129, 

    COLOR_BGRA2YUV_I420 = 130, 

    COLOR_RGBA2YUV_IYUV = COLOR_RGBA2YUV_I420, 

    COLOR_BGRA2YUV_IYUV = COLOR_BGRA2YUV_I420, 

    COLOR_RGB2YUV_YV12 = 131, 

    COLOR_BGR2YUV_YV12 = 132, 

    COLOR_RGBA2YUV_YV12 = 133, 

    COLOR_BGRA2YUV_YV12 = 134, 

    COLOR_BayerBG2BGR = 46, 

    COLOR_BayerGB2BGR = 47, 

    COLOR_BayerRG2BGR = 48, 

    COLOR_BayerGR2BGR = 49, 

    COLOR_BayerBG2RGB = COLOR_BayerRG2BGR, 

    COLOR_BayerGB2RGB = COLOR_BayerGR2BGR, 

    COLOR_BayerRG2RGB = COLOR_BayerBG2BGR, 

    COLOR_BayerGR2RGB = COLOR_BayerGB2BGR, 

    COLOR_BayerBG2GRAY = 86, 

    COLOR_BayerGB2GRAY = 87, 

    COLOR_BayerRG2GRAY = 88, 

    COLOR_BayerGR2GRAY = 89, 

    COLOR_BayerBG2BGR_VNG = 62, 

    COLOR_BayerGB2BGR_VNG = 63, 

    COLOR_BayerRG2BGR_VNG = 64, 

    COLOR_BayerGR2BGR_VNG = 65, 

    COLOR_BayerBG2RGB_VNG = COLOR_BayerRG2BGR_VNG, 

    COLOR_BayerGB2RGB_VNG = COLOR_BayerGR2BGR_VNG, 

    COLOR_BayerRG2RGB_VNG = COLOR_BayerBG2BGR_VNG, 

    COLOR_BayerGR2RGB_VNG = COLOR_BayerGB2BGR_VNG, 

    COLOR_BayerBG2BGR_EA = 135, 

    COLOR_BayerGB2BGR_EA = 136, 

    COLOR_BayerRG2BGR_EA = 137, 

    COLOR_BayerGR2BGR_EA = 138, 

    COLOR_BayerBG2RGB_EA = COLOR_BayerRG2BGR_EA, 

    COLOR_BayerGB2RGB_EA = COLOR_BayerGR2BGR_EA, 

    COLOR_BayerRG2RGB_EA = COLOR_BayerBG2BGR_EA, 

    COLOR_BayerGR2RGB_EA = COLOR_BayerGB2BGR_EA, 

    COLOR_BayerBG2BGRA = 139, 

    COLOR_BayerGB2BGRA = 140, 

    COLOR_BayerRG2BGRA = 141, 

    COLOR_BayerGR2BGRA = 142, 

    COLOR_BayerBG2RGBA = COLOR_BayerRG2BGRA, 

    COLOR_BayerGB2RGBA = COLOR_BayerGR2BGRA, 

    COLOR_BayerRG2RGBA = COLOR_BayerBG2BGRA, 

    COLOR_BayerGR2RGBA = COLOR_BayerGB2BGRA, 

    COLOR_COLORCVT_MAX = 143
}
