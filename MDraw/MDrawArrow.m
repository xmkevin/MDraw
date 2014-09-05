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

#import "MDrawArrow.h"

@implementation MDrawArrow

-(void)draw:(CGContextRef)ctx inView:(UIView *)view withoutMeasurement:(BOOL)noMeasurement
{
    
    if(CGPointEqualToPoint(_startPoint, _endPoint))
    {
        return;
    }
    
    CGSize dSize = CGPointOffset(_startPoint, _endPoint);
    //Draw a triagnle as the arrow, the default angle is 15 degree
    //And the default half length is 2x line width.
    float radian = 15.0 /180.0 * M_PI;
    float length = self.lineWidth * 2;
    float x =  length / tanf(radian);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(x, p1.y - length);
    CGPoint p3 = CGPointMake(x, p1.y + length);
    
    float lineRadian = atan2f(dSize.height, dSize.width);
    float xOffset = x * cosf(lineRadian);
    float yOffset = x * sinf(lineRadian);
    CGPoint newStartPoint = CGPointMake(_startPoint.x + xOffset, _startPoint.y + yOffset);
    
    
    CGContextSaveGState(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    //Draw line
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, newStartPoint.x, newStartPoint.y);
    CGContextAddLineToPoint(ctx, _endPoint.x, _endPoint.y);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //Draw the arrow
    CGContextBeginPath(ctx);
    CGContextTranslateCTM(ctx, _startPoint.x,_startPoint.y);
    CGContextRotateCTM(ctx, atan2f(dSize.height,dSize.width));
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
    if (self.selected)
    {
        [self drawHandle:ctx atPoint:_startPoint];
        [self drawHandle:ctx atPoint:_endPoint];
    }
    
//    if(!noMeasurement && self.finalized && self.showMeasurement)
//    {
//        [self drawMeasurement:ctx inView:view];
//    }

   
}

@end
