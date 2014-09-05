//
//  MDrawMath.h
//  Motics
//
//  Created by Gao Yongqing on 2/6/14.
//
//



#ifndef Motics_MDrawMath_h
#define Motics_MDrawMath_h

#import <Foundation/Foundation.h>


CG_INLINE float CGPointDistance(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    return sqrt(dx*dx + dy*dy);
}

CG_INLINE CGSize CGPointOffset(CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    return CGSizeMake(dx, dy);
}

CG_INLINE CGPoint CGPointAddOffset(CGPoint p, CGSize offset)
{
    return CGPointMake(p.x + offset.width, p.y + offset.height);
}

CG_INLINE CGPoint CGPointMidPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

CG_INLINE float CGPointToLineDistance(CGPoint p, CGPoint p1,CGPoint p2)
{
    float a = p1.y - p2.y;
    float b = p2.x - p1.x;
    float c = (p1.x - b) * p1.y - p1.x * (p1.y + a);
    
    return fabsf(a * p.x + b * p.y + c) / sqrtf(a*a + b*b);
}

CG_INLINE BOOL CGPointInRect(CGPoint p, CGRect rect)
{
    return (p.x >= rect.origin.x &&
            p.x <= (rect.origin.x + rect.size.width) &&
            p.y >= rect.origin.y &&
            p.y <= (rect.origin.y + rect.size.height));
}

CG_INLINE CGPoint CGRectTL(CGRect rect)
{
    return rect.origin;
}

CG_INLINE CGPoint CGRectTM(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y);
}

CG_INLINE CGPoint CGRectTR(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}

CG_INLINE CGPoint CGRectRM(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.5);
}

CG_INLINE CGPoint CGRectBR(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

CG_INLINE CGPoint CGRectBM(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height);
}

CG_INLINE CGPoint CGRectBL(CGRect rect)
{
    return CGPointMake(rect.origin.x , rect.origin.y + rect.size.height);
}

CG_INLINE CGPoint CGRectLM(CGRect rect)
{
    return CGPointMake(rect.origin.x , rect.origin.y + rect.size.height * 0.5);
}

CG_INLINE CGPoint CGRectMid(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.5);
}

/**
 *  三点画圆，计算圆心X坐标
 *  三点确定的圆的圆心到三点的距离相等，就有以下两个不等式：
 * (x - x1 )^2 + (y-y1) ^2 = (x-x2)^2 + (y-y2)^2 = (x-x3)^2 + (y-y3)^2
 * 根据两个不等式，可以推出 x 和 y
 *
 *  @param x1 x of point 1
 *  @param y1 y of point 1
 *  @param x2 x of point 2
 *  @param y2 y of point 2
 *  @param x3 x of point 3
 *  @param y3 y of point 3
 *
 *  @return x of center point
 */
CG_INLINE CGFloat CGCenterX(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2,CGFloat x3, CGFloat y3)
{
    CGFloat x = ((x1 * x1 + y1 * y1) * (y2 - y3) - (x2 * x2 + y2 * y2) * (y2 - y3)
             - (x2 * x2 + y2 * y2) * (y1 - y2) + (x3 * x3 + y3 * y3) * (y1 - y2))
    / (2 * ((x1 - x2) * (y2 - y3) - (x2 - x3) * (y1 - y2)));
    
    return x;
}

CG_INLINE CGFloat CGCenterY(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2,CGFloat x3, CGFloat y3)
{
    CGFloat x = CGCenterX(x1, y1, x2, y2, x3, y3);
    CGFloat y = ((x2 * x2 + y2 * y2) - (x3 * x3 + y3 * y3) - 2 * x * (x2 - x3))
    / (2 * (y2 - y3));
    
    return y;
}

CG_INLINE CGPoint CGCenterPoint(CGPoint p1, CGPoint p2, CGPoint p3)
{
    CGFloat x = CGCenterX(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    CGFloat y = CGCenterY(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    
    return CGPointMake(x, y);
}

/**
 * 计算圆的半径
 **/
CG_INLINE CGFloat CGRadius(CGPoint centerPoint,CGPoint edgePoint)
{
    return sqrtf((edgePoint.x - centerPoint.x) * (edgePoint.x - centerPoint.x) +
                     (edgePoint.y - centerPoint.y) * (edgePoint.y - centerPoint.y));
}

/**
 * 求三点构成的角的弧度，其中中间那点（x2，y2）是角度的顶点
 **/
CG_INLINE CGFloat CGAngleRadianS(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x3, CGFloat y3)
{
    CGFloat a1 = atan2f(y1 - y2, x1 - x2);
    CGFloat a2 = atan2f(y3 - y2, x3 - x2);
    
    return a2 - a1;
}

CG_INLINE CGFloat CGAngleRadian(CGPoint p1, CGPoint p2, CGPoint p3)
{
    return CGAngleRadianS(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
}

/**
 * 求三点构成的角度，其中中间那点（x2，y2）是角度的顶点
 **/
CG_INLINE CGFloat CGAngleDegreeS(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat x3, CGFloat y3)
{
    CGFloat radian = CGAngleRadianS(x1, y1, x2, y2, x3, y3);
    CGFloat degree = radian / M_PI * 180;
    if (degree < 0) {
        return 360 + degree;
    }
    else {
        return degree;
    }
}

/**
 * 求三点构成的角的角度，其中中间那点p2是角的顶点
 **/
CG_INLINE CGFloat CGAngleDegree(CGPoint p1, CGPoint p2, CGPoint p3)
{
    CGFloat radian = CGAngleRadian(p1, p2, p3);
    CGFloat degree = radian / M_PI * 180;
    if (degree < 0) {
        return 360 + degree;
    }
    else {
        return degree;
    }
}

/**
 * 求向量的弧度
 * p1 为原点
 **/
CG_INLINE CGFloat CGVectorRadian(CGPoint p1, CGPoint p2)
{
    return atan2f(p2.y - p1.y, p2.x - p1.x);
}

/// <summary>
/// 求角度所对应的弧上的一点
/// </summary>
/// <param name="xCenter">中间点的X坐标</param>
/// <param name="yCenter">中间点的Y坐标</param>
/// <param name="x"></param>
/// <param name="y"></param>
/// <param name="arcLength">这个弧的长度，一般是固定的</param>
/// <returns></returns>
CG_INLINE CGPoint CGAngleArcPointS(CGFloat xCenter, CGFloat yCenter, CGFloat x,CGFloat y, CGFloat arcLength)
{
    CGFloat angle = atan2(y - yCenter, x - xCenter);
    CGFloat height = sin(angle) * arcLength;
    CGFloat width = cos(angle) * arcLength;
    
    return CGPointMake(xCenter + width, yCenter +height);
}

CG_INLINE BOOL IsLargeArc(CGFloat radian)
{
    //如果弧度小余0，用2π - 弧度来计算
    CGFloat absR = radian < 0 ? 2 * M_PI + radian : radian;
    
    return absR < 0.5 * M_PI || absR > 1.5 * M_PI;
}

/**
 * 是否是逆时针
 **/
CG_INLINE BOOL IsCounterClockwise(CGFloat radian)
{
    //如果弧度小余0，用2π - 弧度来计算
    CGFloat absR = radian < 0 ? 2 * M_PI + radian : radian;
    return absR > 0 && absR < M_PI;
}


/**
 * 多边形的面积
 **/
CG_INLINE CGFloat CGPolygonArea(NSArray *points)
{
    int count = points.count;
    int i, j;
    CGFloat area = 0;
    
    for (i = 0; i < count; i++) {
        j = (i + 1) % count;
        
        CGPoint pi = [points[i] CGPointValue];
        CGPoint pj = [points[j] CGPointValue];
        
        area += pi.x * pj.y;
        area -= pi.y * pj.x;
    }
    
    area /= 2.0;
    
    return abs(area);
    
}

/**
 * 多边形的周长
 **/
CG_INLINE CGFloat CGPolygonLength(NSArray *points)
{
    if(points.count < 2)
    {
        return 0;
    }
    
    NSInteger count = points.count;
    CGFloat length = 0.0;
    for (int i = 1; i < count; i++)
    {
        length += CGPointDistance([points[i - 1] CGPointValue], [points[i] CGPointValue]);
    }
    
    return length;
}

/**
 * 闭合多边形的周长
 **/
CG_INLINE CGFloat CGPolygonLengthClosed(NSArray *points)
{
    if(points.count < 2)
    {
        return 0;
    }
    
    CGFloat length = CGPolygonLength(points);
    // Add last line length
    length += CGPointDistance([points[0] CGPointValue], [points[points.count -1] CGPointValue]);
    
    return length;
}

CG_INLINE CGPoint CGArcPointParameter(CGPoint p1, CGPoint p2, CGPoint p3, float u)
{
    CGFloat x = (powf(1 - u, 2) * p1.x) +
    (2 * u * (1 - u) * p2.x ) +
    (powf(u, 2) * p3.x);
    
    CGFloat y = (powf(1 - u, 2) * p1.y) +
    (2 * u * (1 - u) * p2.y ) +
    (powf(u, 2) * p3.y);
    
    return CGPointMake(x, y);
}

CG_INLINE float CGArcLength(CGPoint p1, CGPoint p2, CGPoint p3)
{
    float u = 0;
    float length = 0;
    CGPoint pt1 = CGArcPointParameter(p1, p2, p3, u);
    for (int i = 0; i < 10; i++) {
        u += 0.1;
        if ( u > 1 ) {
            u = 1;
        }
        CGPoint pt2 = CGArcPointParameter(p1, p2, p3, u);
        length += CGPointDistance(pt1, pt2);
        pt1 = pt2;
    }
    return length;
}





#endif
