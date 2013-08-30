//    The MIT License (MIT)
//
//    Copyright (c) 2013 xmkevin
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#define HANDLE_SIZE 20
#define NEAR_WIDTH 10

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

@protocol MDrawToolProtocol<NSObject>

/**
 * Is the tool selected
 **/
@property (nonatomic) BOOL selected;

/**
 * Is the tool finalized (finish drawing)
 **/
@property (nonatomic,readonly) BOOL finalized;

/**
 * Frame of this tool
 **/
@property (nonatomic,readonly) CGRect frame;

/**
 * Line width
 **/
@property (nonatomic)CGFloat lineWidth;

/**
 * Line color
 **/
@property (nonatomic,strong)UIColor *color;

/**
 * Fill color
 **/
@property (nonatomic,strong)UIColor *fillColor;


/**
 * Init the tool with a start point.
 **/
-(id)initWithStartPoint:(CGPoint )startPoint;

/**
 * Draw mouse down (touchesBegan)
 **/
-(void)drawDown:(CGPoint)point;

/**
 * Draw mouse move (touchesMove)
 **/
-(void)drawMove:(CGPoint)point;

/**
 * Draw mouse up (touchesEnd)
 **/
-(void)drawUp:(CGPoint)point;

/**
 * Finalize the drawing
 **/
-(void)finalize;

/**
 * Hit test to see whether or not the point is on the tool
 **/
-(BOOL)hitTest:(CGPoint)point;

/**
 * Determine whether or not the point hits a handle
 * If it hits a handle, then it can move the tool
 **/
-(BOOL)hitOnHandle:(CGPoint)point;

/**
 * Move the tool or the selected handle to the new position.
 **/
-(void)moveToPoint:(CGPoint)point;

/**
 * Draw itself on the contex
 **/
-(void)draw:(CGContextRef)ctx;

@end

/**
 * Base class of draw tool
 **/
@interface MDrawTool : NSObject <MDrawToolProtocol>
{
    @protected
    BOOL _finalized;
    CGPoint _startPoint, _endPoint;
}


-(void)drawHandle:(CGContextRef)ctx atPoint:(CGPoint)point;
-(BOOL)isPoint:(CGPoint)point onHandle:(CGPoint)handlePoint;

@end
