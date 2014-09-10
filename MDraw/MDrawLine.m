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

#import "MDrawLine.h"

@implementation MDrawLine
{
    // 0 : no hited, 1 : startPoint, 2: endPoint, 3: Middle point
    int _handleHitStatus;
}

-(BOOL)hitTest:(CGPoint)point
{
    float distance = CGPointToLineDistance(point, _startPoint, _endPoint);
    if(distance <= NEAR_WIDTH)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)hitOnHandle:(CGPoint)point
{
    _handleHitStatus = 0;
    
    if([self isPoint:point onHandle:_startPoint])
    {
        _handleHitStatus = 1;
        return YES;
    }
    
    if([self isPoint:point onHandle:_endPoint])
    {
        _handleHitStatus = 2;
        return YES;
    }
    
    if([self hitTest:point])
    {
        _handleHitStatus = 3;
        return YES;
    }
    
    return NO;
}

-(void)moveByOffset:(CGSize)offset
{
    
    if(_handleHitStatus == 1)
    {
        _startPoint = CGPointAddOffset(_startPoint, offset);
    }
    else if(_handleHitStatus == 2)
    {
        _endPoint = CGPointAddOffset(_endPoint, offset);
    }
    else if(_handleHitStatus == 3)
    {
        _startPoint.x += offset.width;
        _startPoint.y += offset.height;
        _endPoint.x += offset.width;
        _endPoint.y += offset.height;
    }
}

-(void)stopMoveHandle
{
    _handleHitStatus = 0;
}

-(void)drawDown:(CGPoint)point
{
    _startPoint = point;
    _endPoint = point;
}

-(void)drawMove:(CGPoint)point
{
    _endPoint = point;
}

-(void)drawUp:(CGPoint)point
{
    if(self.finalized)
    {
        return;
    }
    
    _endPoint = point;
    
    if(!CGPointEqualToPoint(_startPoint, point))
    {
        [self finalize];
    }
}

-(void)finalize
{
    _finalized = YES;
    self.selected = YES;
}

-(void)draw:(CGContextRef)ctx
{
    CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(ctx, _endPoint.x, _endPoint.y);
    CGContextStrokePath(ctx);
    
    if (self.selected)
    {
        [self drawHandle:ctx atPoint:_startPoint];
        [self drawHandle:ctx atPoint:_endPoint];
    }

}

-(NSString *)measureText
{
    static NSString *lengthText;
    if(!lengthText)
    {
        lengthText = NSLocalizedString(@"Length", nil);
    }
    
    CGFloat length = CGPointDistance(_startPoint, _endPoint);
    length = [self unitConvert:length isSquare:NO];
    
    return [NSString stringWithFormat:@"%@ : %0.2f %@",
                      lengthText,
                      length,
                      self.unit];
    
}

@end
